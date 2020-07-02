module RS4
  # Standard Error returning a simple message
  # Should be extended by additional classes
  # to provide needed behavior
  class Error
    attr_accessor :message

    def initialize(message)
      @message = message
    end
  end
end
