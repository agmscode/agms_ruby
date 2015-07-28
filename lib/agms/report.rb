module Agms
  class Report < Agms
    # API object for the Reporting/Query API

    alias AgmsResetParameters resetParameters
    alias AgmsSetParameter setParameter
    alias AgmsDoConnect doConnect

    def initialize
      super()
      @trans_api_url = 'https://gateway.agms.com/roxapi/agms.asmx'
      @safe_api_url = 'https://gateway.agms.com/roxapi/AGMS_SAFE_API.asmx'
      @requestObject = 'ReportRequest'
      @responseObject = 'ReportResponse'
    end

    # @return [Object]
    def listTransactions(params)
      @op = 'TransactionAPI'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    # @return [Object]
    def listSAFEs(params)
      @op = 'QuerySAFE'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    protected
    def execute
      if @op == 'TransactionAPI'
        @api_url = @trans_api_url
        AgmsDoConnect('TransactionAPI', @responseObject)
      elsif @op == 'QuerySAFE'
        @api_url = @safe_api_url
        AgmsDoConnect('QuerySAFE', @responseObject)
      else
        raise InvalidRequestError, "Invalid request to Transaction API #{@op}"
      end
    end

  end
end
