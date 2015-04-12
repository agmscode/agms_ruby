module Agms
  class ClientErrorError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end