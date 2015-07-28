module Agms
  class SAFE < Agms
    # API object for the Customer SAFE API

    alias AgmsResetParameters resetParameters
    alias AgmsSetParameter setParameter
    alias AgmsDoConnect doConnect

    def initialize
      super()
      # @api_url = 'https://gateway.agms.com/roxapi/AGMS_SAFE_API.asmx'
      @api_url = 'https://gateway.agms.com/roxapi/agms.asmx'
      @requestObject = 'SAFERequest'
      @responseObject = 'SAFEResponse'
    end

    # @return [Object]
    def add(params)
      @op = 'AddToSAFE'
      AgmsResetParameters()
      AgmsSetParameter(:SAFE_Action, {:value => 'add_safe'})
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    # @return [Object]
    def update(params)
      @op = 'UpdateSAFE'
      AgmsResetParameters()
      AgmsSetParameter(:SAFE_Action, {:value => 'update_safe'})
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    # @return [Object]
    def delete(params)
      @op = 'DeleteFromSAFE'
      AgmsResetParameters()
      AgmsSetParameter(:SAFE_Action, {:value => 'delete_safe'})
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    protected
    def execute
      if @op == 'AddToSAFE'
        AgmsDoConnect('ProcessTransaction', @responseObject)
      elsif @op == 'UpdateSAFE'
        AgmsDoConnect('ProcessTransaction', @responseObject)
      elsif @op == 'DeleteFromSAFE'
        AgmsDoConnect('ProcessTransaction', @responseObject)
      else
        raise InvalidRequestError, "Invalid request to Transaction API #{@op}"
      end
    end

  end
end
