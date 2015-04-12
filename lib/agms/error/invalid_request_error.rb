module Agms
	class InvalidRequestError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end