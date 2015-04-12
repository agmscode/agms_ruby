module Agms
	class RequestValidationError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end