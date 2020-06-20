module RS4
  # The standard error returned when a request to the RS4
  # API fails
  # code - the NetHTTP response code as a number (eg - 200)
  # error_class - which NetHTTP class was returned by the response
  # message - the error message (if any) returned in the response
  class RequestError
    attr_accessor :code
    attr_accessor :error_class
    attr_accessor :message

    def initialize(code, error_class, message)
      @code = code
      @error_class = error_class
      @message = message
    end
  end
end
