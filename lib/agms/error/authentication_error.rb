module Agms
  class AuthenticationError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end