# frozen_string_literal: true

module RS4
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :request_handler
    attr_accessor :private_api_key
    attr_accessor :api_host
    attr_accessor :errors

    def valid?
      @errors = []

      @errors << '`private_api_key` not set' unless private_api_key.present?
      @errors << '`api_host` not set' unless api_host.present?

      if @errors.any?
        Rails.logger.error("RS4 Configuration Invalid: #{@errors.join(',')}")
        return false
      else
        return true
      end
    end
  end
end
