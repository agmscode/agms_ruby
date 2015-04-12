module Agms
  class ForgedQueryStringError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end