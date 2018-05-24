#!/usr/bin/env ruby

require 'rest-client'

def main
  url = 'https://api.github.com/repos/rails/rails/issues'
  response = RestClient.get url
end

if __FILE__ == $0
  main
end
