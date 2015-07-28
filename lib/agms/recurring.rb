module Agms
  class Recurring < Agms
    # API object for the Recurring API

    alias AgmsResetParameters resetParameters
    alias AgmsSetParameter setParameter
    alias AgmsDoConnect doConnect

    def initialize
      super()
      @api_url = 'https://gateway.agms.com/roxapi/AGMS_Recurring.asmx'
      @requestObject = 'RecurringRequest'
      @responseObject = 'RecurringResponse'
    end

    # @return [Object]
    def add(params)
      @op = 'RecurringAdd'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    # @return [Object]
    def update(params)
      @op = 'RecurringUpdate'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    # @return [Object]
    def delete(params)
      @op = 'RecurringDelete'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    # @return [Object]
    def get(params)
      @op = 'RetrieveRecurringID'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    protected
    def execute
      if @op == 'RecurringAdd'
        AgmsDoConnect('RecurringAdd', @responseObject)
      elsif @op == 'RecurringUpdate'
        AgmsDoConnect('RecurringUpdate', @responseObject)
      elsif @op == 'RecurringDelete'
        AgmsDoConnect('RecurringDelete', @responseObject)
      elsif @op == 'RetrieveRecurringID'
        AgmsDoConnect('RetrieveRecurringID', @responseObject)
      else
        raise InvalidRequestError, "Invalid request to Transaction API #{@op}"
      end
    end

  end
end
