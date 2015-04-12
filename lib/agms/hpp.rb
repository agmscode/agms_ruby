module Agms
  class HPP < Agms
    # A class representing AGMS HPP objects.

    alias AgmsResetParameters resetParameters
    alias AgmsSetParameter setParameter
    alias AgmsDoConnect doConnect

    def initialize
      super()
      @api_url = 'https://gateway.agms.com/roxapi/AGMS_HostedPayment.asmx'
      @requestObject = 'HPPRequest'
      @responseObject = 'HPPResponse'
    end

    # @return [Object]
    def generate(params)
      @op = 'ReturnHostedPaymentSetup'
      AgmsResetParameters()
      params.each do |param, config|
        AgmsSetParameter(param, config)
      end
      self.execute()
      return @response.toArray()
    end

    # @return [String]
    def getHash
      return @hash
    end

    # @return [String]
    def getLink
      if not @hash
        raise UnexpectedError, 'Requested HPP link but no hash generated in HPP.'
      else
        format_field = @request.getField(:HPPFormat)
        if format_field[:value]
          if format_field[:value] == '1'
            return "https://gateway.agms.com/HostedPaymentForm/HostedPaymentPage.aspx?hash=#{@hash}"
          else
            return "https://gateway.agms.com/HostedPaymentForm/HostedPaymentPage2.aspx?hash=#{@hash}"
          end
        else
          if @@Configuration.Hpp_Template == 'TEMPLATE_1'
            return "https://gateway.agms.com/HostedPaymentForm/HostedPaymentPage.aspx?hash=#{@hash}"
          else
            return "https://gateway.agms.com/HostedPaymentForm/HostedPaymentPage2.aspx?hash=#{@hash}"
          end
        end
      end
    end

    protected
    def execute
      if @op == 'ReturnHostedPaymentSetup'
        AgmsDoConnect('ReturnHostedPaymentSetup', @responseObject)
        @hash = @response.getHash
      else
        raise InvalidRequestError, "Invalid request to Transaction API #{@op}"
      end
    end

  end
end
