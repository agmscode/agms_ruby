module Agms
  class HPPResponse < Response
    # A class representing AGMS HPP Response objects.

    def initialize(response, op)
      super(response, op)
      @op = op
      @mapping = {'0' => 'hash', }
      @response = Hash.new
      @response['0'] = response
      @hash = response

      if not isSuccessful()
        raise ResponseError, 'HPP Generation failed with message ' + @hash
      end
    end

    def getHash
      return @hash
    end

    def isSuccessful
      @hash = getHash()
      if ( not @hash or
          @hash == 0 or
          @hash.include? 'INVALID' or
          @hash.include? 'ERROR' or
          @hash.include? 'EXCEPTION' or
          @hash.include? 'REQUIRED' or
          @hash.include? 'IF USED' or
          @hash.include? 'MUST BE' or
          @hash.include? 'FAILED')
          return false
      else
          return true
      end
    end
  end
end