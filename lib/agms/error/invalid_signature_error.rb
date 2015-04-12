module Agms
	class InvalidSignatureError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end