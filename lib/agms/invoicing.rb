module Agms
  class Invoicing < Agms
    # A class representing AGMS Invoicing objects.

    alias AgmsResetParameters resetParameters
    alias AgmsSetParameter setParameter
    alias AgmsDoConnect doConnect

    def initialize
      super()
      @api_url = 'https://gateway.agms.com/roxapi/AGMS_BillPay.asmx'
      @requestObject = 'InvoicingRequest'
      @responseObject = 'InvoicingResponse'
    end

    # @return [Object]
    def customer(params)
      @op = 'RetrieveCustomerIDList'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      # self.execute()
      # return @response.toArray()
    end

    # @return [Object]
    def invoice(params)
      @op = 'RetrieveInvoices'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      # self.execute()
      # return @response.toArray()
    end

    # @return [Object]
    def submit(params)
      @op = 'SubmitInvoice'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      # self.execute()
      # return @response.toArray()
    end

    protected
    def execute
      if self.op == 'RetrieveCustomerIDList'
        AgmsDoConnect('RetrieveCustomerIDList', @responseObject)
      elsif self.op == 'RetrieveInvoices'
        AgmsDoConnect('RetrieveInvoices', @responseObject)
      elsif self.op == 'SubmitInvoice'
        AgmsDoConnect('SubmitInvoice', @responseObject)
      else
        raise InvalidRequestError, "Invalid request to Transaction API #{@op}"
      end
    end

  end
end
