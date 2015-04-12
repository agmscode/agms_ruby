module Agms
	class TransactionResponse < Response
    # A class representing AGMS Transaction Response objects.

    def initialize(response, op)
      super(response, op)
      @mapping = {
        'STATUS_CODE' => 'response_code',
        'STATUS_MSG' => 'response_message',
        'TRANS_ID' => 'transaction_id',
        'AUTH_CODE' => 'authorization_code',
        'AVS_CODE' => 'avs_result',
        'AVS_MSG' => 'avs_message',
        'CVV2_CODE' => 'cvv_result',
        'CVV2_MSG' => 'cvv_message',
        'ORDERID' => 'order_id',
        'SAFE_ID' => 'safe_id',
        'FULLRESPONSE' => 'full_response',
        'POSTSTRING' => 'post_string',
        'BALANCE' => 'gift_balance',
        'GIFTRESPONSE' => 'gift_response',
        'MERCHANT_ID' => 'merchant_id',
        'CUSTOMER_MESSAGE' => 'customer_message',
        'RRN' => 'rrn'
      }

      @response = response
      @op = op

      if not isSuccessful()
        response_array = toArray()
        raise ResponseError.new("Transaction failed with error code #{response_array['response_code']}  and message #{response_array['response_message']}", response_array)
      end
    end

    def isSuccessful
      response_array = toArray()
      if response_array['response_code'] != '1' and response_array['response_code'] != '2'
        return false
      else
        return true
      end
    end

    def getAuthorization
      response_array = toArray()
      return response_array['transaction_id']
    end
	end
end