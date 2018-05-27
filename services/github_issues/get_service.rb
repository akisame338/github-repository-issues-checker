require 'csv'
require 'json'
require 'rest-client'

module Services
  module GithubIssues
    class GetService

      # @param url [String] リクエストURL
      # @param page [Integer] Issues取得対象ページ（デフォルト：1）
      def initialize(url, page=1)
        @url  = url
        @page = page
      end

      # @return [String] Issuesのtitleの先頭30文字、bodyの先頭50文字、html_urlをCSV形式とした文字列
      def exec
        response = RestClient.get @url, {params: {page: @page}}
        issues = JSON.parse response.body

        csv_data = CSV.generate({:force_quotes => true}) do |csv|
          issues.each do |issue|
            csv << [issue['title'][0, 30], issue['body'][0, 50], issue['html_url']]
          end
        end
      end

    end
  end
end
