module Jira
  class CLI < Thor

    desc "assign", "Assign a ticket to a user"
    def assign(ticket=Jira::Core.ticket)
      # determine assignee
      assignee = self.io.ask("Assignee (default auto)").strip
      if assignee.empty?
        assignee = "-1" # automatic assignee is used
      end

      self.api.put("issue/#{ticket}/assignee", { name: assignee }) do |json|
        return
      end
      puts "No ticket assigned."
    end

  end
end
