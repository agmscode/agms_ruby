module Agms
	class ConfigurationError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end