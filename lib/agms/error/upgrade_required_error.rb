module Agms
	class UpgradeRequiredError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end