module Agms
  class NotFoundError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end