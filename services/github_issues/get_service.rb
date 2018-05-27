require 'csv'
require 'json'
require 'rest-client'

module Services
  module GithubIssues
    class GetService

      # @param url [String] リクエストURL
      # @param page [Integer] Issues取得対象ページ（デフォルト：1）
      def initialize(url, page=1)
        if !is_valid_url? url
          raise "'#{url}' is invalid URL"
        end

        @url  = url
        @page = page
      end

      # @return [String] Issuesのtitleの先頭30文字、bodyの先頭50文字、html_urlをCSV形式とした文字列
      def exec
        # TODO: リクエストパラメータとレスポンスのログ出力処理を追加
        # TODO: レスポンスが正常系か否かの判定を追加
        # TODO: レスポンスに応じたリトライ処理を追加
        response = request

        issues = parse response
        to_csv issues
      end

      private

      # @param url [String] リクエストURL
      # @return [Boolean] リクエストURLが適切か否か
      # @see https://developer.github.com/v3/issues/#list-issues-for-a-repository
      def is_valid_url?(url)
        !(url =~ /https:\/\/api\.github\.com\/repos\/.+\/.+\/issues/).nil?
      end

      # @return Issues取得APIのレスポンス
      def request
        RestClient.get @url, {params: {page: @page}}
      end

      # @param response Issues取得APIのレスポンス
      # @return [Array] Issuesのハッシュ
      def parse(response)
        JSON.parse response.body
      end

      # @param issues [Array] Issuesのハッシュ
      # @return [String] Issuesのtitleの先頭30文字、bodyの先頭50文字、html_urlをCSV形式とした文字列
      def to_csv(issues)
        CSV.generate({:force_quotes => true}) do |csv|
          issues.each do |issue|
            csv << [issue['title'][0, 30], issue['body'][0, 50], issue['html_url']]
          end
        end
      end

    end
  end
end
