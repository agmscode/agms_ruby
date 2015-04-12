module Agms
  class InvalidParameterError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end