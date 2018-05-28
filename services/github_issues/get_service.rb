require 'csv'
require 'json'
require 'logger'
require 'rest-client'
require_relative 'get_service_error.rb'

module Services
  module GithubIssues
    class GetService
      REST_CLIENT_LOG_FILE_NAME = 'rest-client.log'

      # @param url [String] リクエストURL
      # @param page [Integer] Issues取得対象ページ（デフォルト：1）
      # @return [String] Issuesのtitleの先頭30文字、bodyの先頭50文字、html_urlをCSV形式とした文字列
      def self.exec(url, page=1)
        if !is_valid_url? url
          raise Services::GithubIssues::GetServiceError, "'#{url}' is invalid URL"
        end

        # TODO: レスポンスが正常系か否かの判定を追加
        # TODO: レスポンスに応じたリトライ処理を追加
        response = request url, page

        issues = parse response
        to_csv issues
      end

      private

      # @param url [String] リクエストURL
      # @return [Boolean] リクエストURLが適切か否か
      # @see https://developer.github.com/v3/issues/#list-issues-for-a-repository
      def self.is_valid_url?(url)
        !(url =~ /https:\/\/api\.github\.com\/repos\/.+\/.+\/issues/).nil?
      end

      # @param url [String] リクエストURL
      # @param page [Integer] Issues取得対象ページ
      # @return Issues取得APIのレスポンス
      def self.request(url, page)
        # @see https://qiita.com/kotaroito/items/d96182c8055ca1242b02
        log_file = log_path REST_CLIENT_LOG_FILE_NAME
        RestClient.log = Logger.new(log_file)

        RestClient.get url, {params: {page: page}}
      end

      # @param log_file_name [String] ログファイル名
      # @return [String] ログファイルのパス
      def self.log_path(log_file_name)
        File.expand_path('../../../log', __FILE__) + '/' + log_file_name
      end

      # @param response Issues取得APIのレスポンス
      # @return [Array] Issuesのハッシュ
      def self.parse(response)
        JSON.parse response.body
      end

      # @param issues [Array] Issuesのハッシュ
      # @return [String] Issuesのtitleの先頭30文字、bodyの先頭50文字、html_urlをCSV形式とした文字列
      def self.to_csv(issues)
        CSV.generate({:force_quotes => true}) do |csv|
          issues.each do |issue|
            csv << [issue['title'][0, 30], issue['body'][0, 50], issue['html_url']]
          end
        end
      end

    end
  end
end
