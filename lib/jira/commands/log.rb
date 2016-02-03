module Jira
  class CLI < Thor

    desc 'log', 'log subcommands'
    subcommand 'log', Log

  end
end
