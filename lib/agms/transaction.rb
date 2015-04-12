module Agms
	class Transaction < Agms
		# A class representing AGMS Transaction objects.
		
		alias AgmsResetParameters resetParameters
		alias AgmsSetParameter setParameter
		alias AgmsDoConnect doConnect

		def initialize
			super()
      @api_url = 'https://gateway.agms.com/roxapi/agms.asmx'
      @requestObject = 'TransactionRequest'
      @responseObject = 'TransactionResponse'
		end

    # @return [Object]
    def process(params)
      @op = 'ProcessTransaction'
      AgmsResetParameters()
      params.each do |param, config|
				AgmsSetParameter(param, config)
			end
			self.execute()
			return @response.toArray()
		end

		protected
			def execute
				if @op == 'ProcessTransaction'
					AgmsDoConnect('ProcessTransaction', @responseObject)
				else
					raise InvalidRequestError, "Invalid request to Transaction API #{@op}"
				end
			end

	end
end
