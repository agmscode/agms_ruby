module Agms
  class ServerErrorError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end