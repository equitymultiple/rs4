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

    def initialize
      @private_api_key = nil
      @api_host = nil
    end
  end
end
