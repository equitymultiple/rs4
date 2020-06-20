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
    attr_accessor :private_api_key
    attr_accessor :api_host
  end
end
