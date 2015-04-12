module Agms
	class ResponseError < AgmsError
        def initialize(message, object)
        	super(message, object)
        end
    end
end