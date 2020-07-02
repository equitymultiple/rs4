module RS4
  # Prepares the HTTP request with the headers
  # required by the RS4 endpoints
  class Request
    # Reattempt the request before giving up
    MAX_RETRIES = 5

    class << self
      def execute(path, method = :get, body = {})
        # Check required keys exist before continuing
        unless RS4.configuration.valid?
          return RS4::ConfigurationError.new(RS4.configuration.errors, 'Invalid Configuration')
        end

        url = URI(RS4.configuration.api_host + '/public/v1/' + path)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = case method
                  when :get
                    Net::HTTP::Get.new(url)
                  when :post
                    Net::HTTP::Post.new(url)
                  when :put
                    Net::HTTP::Put.new(url)
                  when :delete
                    Net::HTTP::Delete.new(url)
                  end

        request.body = body.to_json unless method == :get
        request['Content-Type'] = 'application/json' unless method == :get
        request['Authorization'] = "Basic #{Base64.strict_encode64(RS4.configuration.private_api_key)}"

        # https://stackoverflow.com/questions/5370697/what-s-the-best-way-to-handle-exceptions-from-nethttp#answer-11802674
        begin
          retries ||= 0
          response = http.request(request)

          result = if response.class == Net::HTTPOK
                     JSON.parse(response.body, symbolize_names: true)
                   else
                     RS4::RequestError.new(
                       response.code,
                       response.class,
                       JSON.parse(response.read_body)
                     )
                   end

          result
        rescue StandardError => e
          Rails.logger.error(e)
          retry if (retries += 1) < MAX_RETRIES
        end
      end
    end
  end
end
