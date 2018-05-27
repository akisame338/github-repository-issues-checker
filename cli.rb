#!/usr/bin/env ruby

require_relative 'services/github_issues/get_service.rb'

def main
  url  = 'https://api.github.com/repos/rails/rails/issues'

  puts Services::GithubIssues::GetService.exec url
end

if __FILE__ == $0
  main
end
