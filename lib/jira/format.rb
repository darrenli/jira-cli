module Jira
  class Format
    class << self

      def star
        "#{Thor::Shell::Color::BOLD}"\
        "#{Thor::Shell::Color::YELLOW}"\
        "*"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def ticket(ticket)
        "#{Thor::Shell::Color::RED}"\
        "#{ticket}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def status(status)
        "["\
        "#{Thor::Shell::Color::BLUE}"\
        "#{status}"\
        "#{Thor::Shell::Color::CLEAR}"\
        "]"
      end

      def summary(summary)
        "#{Thor::Shell::Color::BOLD}"\
        "#{Thor::Shell::Color::WHITE}"\
        "#{summary}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def user(user)
        "#{Thor::Shell::Color::MAGENTA}"\
        "#{user}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def time(time)
        "#{Thor::Shell::Color::BLUE}"\
        "#{time.strftime('%l:%M%P on %b %d, %Y').strip}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def comment(comment)
        comment = self.wrap(comment)
        comment.gsub!(/\[~[a-z]+\]/, '[[[\0]]]')
        comment.gsub!(
          '[[[[~',
          "#{Thor::Shell::Color::BOLD}"\
          "#{Thor::Shell::Color::WHITE}"\
          "("\
          "#{Thor::Shell::Color::MAGENTA}"\
          "@"
        )
        comment.gsub!(
          ']]]]',
          "#{Thor::Shell::Color::WHITE}"\
          ")"\
          "#{Thor::Shell::Color::CLEAR}"
        )
        comment
      end

      def wrap(text)
        width = 80
        text.split("\n").collect do |line|
          if line.length > width
            line.gsub(/(.{1,#{width}})(\s+|$)/, "\\1\n").strip
          else
            line
          end
        end * "\n"
      end

    end
  end
end
