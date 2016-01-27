require_relative '../command'

module Jira
  class CLI < Thor

    desc "delete", "Deletes a ticket in JIRA and the git branch"
    method_option :force, type: :boolean, default: false
    def delete(ticket=Jira::Core.ticket)
      Command::Delete.new(ticket, options[:force]).run
    end

  end

  module Command
    class Delete < Base

      attr_accessor :ticket, :force

      def initialize(ticket, force)
        self.ticket = ticket
        self.force = force
      end

      def run
        return if ticket.empty?
        return if metadata.empty?
        return if metadata['fields'].nil?
        return if subtasks_failure?

        begin
          api.delete "issue/#{ticket}?deleteSubtasks=#{force}",
            success: on_success,
            failure: on_failure
        rescue CommandException => e
          puts e.message
        end
      end

      private

      def on_success
        -> do
          on_failure and return if !create_branch?
          on_failure and return if !delete_branch?
        end
      end

      def on_failure
        -> { puts "No change made to ticket #{ticket}." }
      end

      def branches
        branches = `git branch --list 2> /dev/null`.split(' ')
        branches.delete("*")
        branches.delete("#{ticket}")
        branches
      end

      def create_branch?
        response = self.io.yes?("Create branch?")

        if branches.count == 1 or response
          io.say("Creating a new branch.")
          new_branch = io.ask("Branch?").strip
          new_branch.delete!(" ")
          on_failure and return false if new_branch.empty?
          `git branch #{new_branch} 2> /dev/null`
        end
        true
      end

      def delete_branch?
        response = self.io.select("Select a branch:", branches)
        `git checkout #{response} 2> /dev/null`
        `git branch -D #{ticket} 2> /dev/null`
        true
      end

      def subtasks_failure?
        issue_type = metadata['fields']['issuetype']
        if !issue_type['subtask']
          if !metadata['fields']['subtasks'].empty? && !force
            self.force = io.yes?("Delete all sub-tasks for ticket #{ticket}?")
            return true if !force
          end
        end
        false
      end

      def metadata
        @metadata ||= api.get("issue/#{ticket}")
      end

    end
  end
end
