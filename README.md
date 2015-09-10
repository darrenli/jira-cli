# JIRA CLI [![Gem Version](https://badge.fury.io/rb/jira-cli.png)](http://badge.fury.io/rb/jira-cli)

Ruby gem CLI tool used to manage JIRA workflows leveraging git

* * *

[![Build Status](https://travis-ci.org/darrenli/jira-cli.png?branch=master)](https://travis-ci.org/darrenli/jira-cli)
[![Dependency Status](https://gemnasium.com/darrenli/jira-cli.png)](https://gemnasium.com/darrenli/jira-cli)
[![Code Climate](https://codeclimate.com/github/darrenli/jira-cli.png)](https://codeclimate.com/github/darrenli/jira-cli)

### Available Commands

    jira all             # Describes all local branches that match JIRA ticketing syntax
    jira browse          # Opens the current input ticket in your browser
    jira comment         # Add a comment to the input ticket
    jira comments        # Lists the comments of the input ticket
    jira commit          # Commits uncommitted work with the ticket name and summary.
    jira clipboard       # Copies the url of the JIRA ticket into the clipboard
    jira describe        # Describes the input ticket
    jira install         # Guides the user through JIRA installation
    jira log             # Logs work against the input ticket
    jira new             # Creates a new ticket in JIRA and checks out the git branch
    jira rename          # Updates the summary of the input ticket
    jira sprint          # Lists all tickets in active sprint
    jira transition      # Transitions the input ticket to the next state
    jira version         # Displays the version
    jira help [COMMAND]  # Describe available commands or one specific command

### Gem Installation

Rubygems:

    gem install jira-cli

Manually:

    git clone git@github.com:darrenli/jira-cli.git
    cd jira-cli
    ./install

### Project Installation

In order to use this tool, you'll need to run the installation script in the
git repository that you're managing via JIRA.

    cd path/to/jira/repo
    jira install

Note: Authentication files are expected to drastically change. Currently, they
are completely unencrypted. Use are your own risk... (see disclaimer above)

### Disclaimer

This tool is in very early alpha and its architecture and commands
are expected to change drastically. Please only use this tool for testing
purposes.

### License

(The MIT License)

Copyright © 2014 Darren Cheng

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
