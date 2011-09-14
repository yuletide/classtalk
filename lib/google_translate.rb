require 'httpclient'
require 'json'
require 'uri'

module Google
  class Translate
    def initialize(key)
      @key = key
      @host = "https://www.googleapis.com"
    end

    def translate(phrase, to, from="en")
      uri = "/language/translate/v2"
      params = "?key=#{@key}&source=#{from}&target=#{to}&q=#{URI.escape(phrase)}"
      client = HTTPClient.new
      JSON.parse(client.get_content(@host + uri + params))['data']['translations'][0]['translatedText'].downcase
    end
  end
end
