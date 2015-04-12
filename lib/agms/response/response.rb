module Agms
	class Response
    # A class representing AGMS Response objects.

    def initialize(response, op)
      @response = response
      @op = op
      @mapping = nil
    end

    def toArray
      return mapResponse(@response)
    end

    def mapResponse(arr)
      if @mapping
        response = doMap(arr)
        return response
      else
        raise UnexpectedError, 'Response mapping not defined for this API.'
      end
    end

    def doMap(arr)
      response = Hash.new
      mapping = @mapping
      if mapping
        # We only map the end of the array containing data
        # If this element is an array, then we map its individual sub-arrays
        # Otherwise, we map
        arr.each do |key, value|

          if value.class == Hash
            response << doMap(value)
          else

            if not mapping.has_key?(key)
              raise UnexpectedError, "Unmapped field #{key} in response."
            else
              response[mapping[key]] = value
            end
          end
        end
      end
      return response
    end
	end
end