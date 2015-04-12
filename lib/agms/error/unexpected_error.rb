module Agms
	class UnexpectedError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end