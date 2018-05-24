#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'rest-client'

def main
  url = 'https://api.github.com/repos/rails/rails/issues'
  response = RestClient.get url
  issues = JSON.parse response.body

  csv_data = CSV.generate({:force_quotes => true}) do |csv|
    issues.each do |issue|
      csv << [issue['title'][0, 30], issue['body'][0, 50], issue['html_url']]
    end
  end

  puts csv_data
end

if __FILE__ == $0
  main
end
