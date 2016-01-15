module Jira
  class CLI < Thor

    desc "log", "Logs work against the input ticket"
    def log(ticket=Jira::Core.ticket)
      time_spent = self.io.ask("Time spent on ticket #{ticket}")
      self.api.post("issue/#{ticket}/worklog", { timeSpent: time_spent }) do |json|
        puts "Successfully logged #{time_spent} on ticket #{ticket}."
      end
    end

    desc "logd", "Deletes work against the input ticket"
    def logd(ticket=Jira::Core.ticket)
      if self.io.agree("List worklogs for ticket #{ticket}")
        logs(ticket)
      end
      idx = self.get_worklog_idx("delete")
      if idx < 0
        puts "No worklog deleted."
        return
      end
      self.api.get("issue/#{ticket}/worklog") do |json|
        worklogs = json['worklogs']
        if idx < worklogs.count
          id = worklogs[idx]['id']
          time_spent = worklogs[idx]['timeSpent']
          self.api.delete("issue/#{ticket}/worklog/#{id}") do |json|
            puts "Successfully deleted #{time_spent} on ticket #{ticket}"
            return
          end
        end
      end
      puts "No worklog deleted."
    end

    desc "logs", "Lists work against the input ticket"
    def logs(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}/worklog") do |json|
        worklogs = json['worklogs']
        if worklogs.count > 0
          worklogs.each do |worklog|
            author = worklog['author']['displayName']
            time = Time.parse(worklog['updated'])
            time_spent = worklog['timeSpent']

            printf "[%2d]", worklogs.index(worklog)
            puts "  #{Jira::Format.user(author)} @ "\
                 "#{Jira::Format.time(time)}:\n"\
                 "#{Jira::Format.comment(time_spent)}"
          end
        else
          puts "There are no worklogs on ticket #{ticket}"
        end
      end
    end

    desc "logu", "Updates work against the input ticket"
    def logu(ticket=Jira::Core.ticket)
      if self.io.agree("List worklogs for ticket #{ticket}")
        logs(ticket)
      end
      idx = self.get_worklog_idx("update")
      if idx < 0
        puts "No worklog updated."
        return
      end
      time_spent = self.io.ask("Time spent on ticket #{ticket}").strip
      if time_spent.empty?
        puts "No worklog updated."
        return
      end
      self.api.get("issue/#{ticket}/worklog") do |json|
        worklogs = json['worklogs']
        if idx < worklogs.count
          id = worklogs[idx]['id']
          self.api.put("issue/#{ticket}/worklog/#{id}", { timeSpent: time_spent }) do |json|
            puts "Successfully updated #{time_spent} on ticket #{ticket}."
            return
          end
        end
      end
      puts "No worklog updated."
    end

    protected

      #
      # Prompts the user for a worklog index, then returns the
      # worklog index; failure is < 0
      #
      # @param description [String] describes the user prompt
      #
      # @return idx [Integer] asked comment index
      #
      def get_worklog_idx(description = "")
        idx = self.io.ask("Index for worklog to #{description}").strip
        if !idx.empty?
          idx = idx.to_i
          if idx < 0
            idx = -1
          end
        else
          idx = -1
        end
        idx
      end

  end
end
