require 'rs4/error.rb'

module RS4
  # Error should be returned when the module has been
  # improperly configured
  class ConfigurationError < Error
    attr_accessor :error_fields

    def initialize(error_fields = [], message)
      super(message)

      @error_fields = error_fields
    end
  end
end
