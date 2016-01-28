module Jira
  class CLI < Thor

    desc "attachments", "View ticket attachments"
    def attachments(ticket=Jira::Core.ticket)
      Command::Attachments.new(ticket).run
    end

  end

  module Command
    class Attachments < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?
        return if metadata.empty?
        return if metadata['fields'].nil?

        attachments=metadata['fields']['attachment']
        if !attachments.nil? and attachments.count > 0
          attachments.each do |attachment|
            name=attachment['filename']
            url=attachment['content']

            puts "#{Jira::Format.user(name)} #{url}"
          end
        else
          puts "No attachments found"
        end
      end

      private

      def metadata
        @metadata ||= api.get("issue/#{ticket}")
      end
    end
  end
end
