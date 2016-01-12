module Jira
  class CLI < Thor

    desc "comment", "Add a comment to the input ticket"
    def comment(ticket=Jira::Core.ticket)
      comment = self.get_comment_body(ticket)
      if !comment.empty?
        self.api.post("issue/#{ticket}/comment", { body: comment }) do |json|
          puts "Successfully posted your comment."
          return
        end
      end
      puts "No comment posted."
    end

    desc "commentd", "Delete a comment to the input ticket"
    def commentd(ticket=Jira::Core.ticket)
      if self.io.agree("List comments for ticket #{ticket}")
        comments(ticket)
      end
      idx = self.get_comment_idx("delete")
      if idx < 0
        puts "No comment deleted."
        return
      end
      self.api.get("issue/#{ticket}") do |json|
        comments = json['fields']['comment']['comments']
        if idx < comments.count
          id = comments[idx]['id']
          self.api.delete("issue/#{ticket}/comment/#{id}") do |json|
            puts "Successfully deleted your comment."
            return
          end
        end
      end
      puts "No comment deleted."
    end

    desc "comments", "Lists the comments of the input ticket"
    def comments(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}") do |json|
        comments = json['fields']['comment']['comments']
        if comments.count > 0
          comments.each do |comment|
            author = comment['author']['displayName']
            time = Time.parse(comment['created'])
            body = comment['body']

            printf "[%2d]", comments.index(comment)
            puts "  #{Jira::Format.user(author)} @ "\
                 "#{Jira::Format.time(time)}:\n"\
                 "#{Jira::Format.comment(body)}"
          end
        else
          puts "There are no comments on issue #{ticket}."
        end
      end
    end

    desc "commentu", "Update a comment to the input ticket"
    def commentu(ticket=Jira::Core.ticket)
      if self.io.agree("List comments for ticket #{ticket}")
        comments(ticket)
      end
      idx = self.get_comment_idx("update")
      if idx < 0
        puts "No comment updated."
        return
      end
      comment = self.get_comment_body(ticket)
      if comment.empty?
        puts "No comment updated."
        return
      end
      self.api.get("issue/#{ticket}") do |json|
        comments = json['fields']['comment']['comments']
        if idx < comments.count
          id = comments[idx]['id']
          self.api.put("issue/#{ticket}/comment/#{id}", { body: comment }) do |json|
            puts "Successfully updated your comment."
            return
          end
        end
      end
      puts "No comment updated."
    end

    protected

      #
      # Prompts the user for a comment body, strips it, then
      # returns a substituted version of it
      #
      # @return comment [String] asked comment body
      #
      def get_comment_body(ticket)
        comment = self.io.ask("Leave a comment for ticket #{ticket}").strip
        if !comment.empty?
          temp = comment.gsub(/\@[a-zA-Z]+/,'[~\0]')
          if temp.nil?
            temp = comment
          end
          temp = temp.gsub('[~@','[~')
          if !temp.nil?
            comment = temp
          end
        end
        comment
      end

      #
      # Prompts the user for a comment index, then returns the
      # comment index; failure is < 0
      #
      # @param description [String] describes the user prompt
      #
      # @return idx [Integer] asked comment index
      #
      def get_comment_idx(description = "")
        idx = self.io.ask("Index for comment to #{description}").strip
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
