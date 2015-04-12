require File.expand_path("../../test_helper", __FILE__)

class TransactionTest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    @trans = Agms::Transaction.new
  end

  def test_successful_sale
    Agms::Connect.any_instance.stubs(:post).returns(successful_sale_response)
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Sale Transaction Successful'
    assert_equal 'Approved', response['response_message'], response['response_message']
    assert_equal '549865', response['transaction_id'], response['transaction_id']
  end

  def test_failed_sale
    Agms::Connect.any_instance.stubs(:post).returns(failed_sale_response)
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0514'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    assert_equal '2', response['response_code'], 'Sale Transaction Failed'
    assert_equal 'Declined', response['response_message'], response['response_message']
    assert_equal '549879', response['transaction_id'], response['transaction_id']
  end

  def test_successful_authorize
    Agms::Connect.any_instance.stubs(:post).returns(successful_authorize_response)
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Auth Transaction Successful'
    assert_equal 'Approved', response['response_message'], response['response_message']
    assert_equal '550945', response['transaction_id'], response['transaction_id']
  end

  def test_failed_authorize
    Agms::Connect.any_instance.stubs(:post).returns(failed_authorize_response)
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0514'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    assert_equal '2', response['response_code'], 'Auth Transaction Failed'
    assert_equal 'Declined', response['response_message'], response['response_message']
    assert_equal '550941', response['transaction_id'], response['transaction_id']
  end

  def test_successful_capture
    Agms::Connect.any_instance.stubs(:post).returns(successful_authorize_response)
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    Agms::Connect.any_instance.stubs(:post).returns(successful_capture_response)
    params = {
        :transaction_type => { :value => 'capture'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Capture Transaction Successful'
    assert_equal 'Capture successful: Approved', response['response_message'], response['response_message']
    assert_equal '550946', response['transaction_id'], response['transaction_id']
  end

  def test_partial_capture
    Agms::Connect.any_instance.stubs(:post).returns(successful_authorize_response)
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    Agms::Connect.any_instance.stubs(:post).returns(partial_capture_response)
    params = {
        :transaction_type => { :value => 'capture'},
        :amount => { :value => '5.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Capture Transaction Successful'
    assert_equal 'Capture successful: Approved', response['response_message'], response['response_message']
    assert_equal '550946', response['transaction_id'], response['transaction_id']
  end

  def test_failed_capture
    Agms::Connect.any_instance.stubs(:post).returns(successful_authorize_response)
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    @trans.process(params)
    Agms::Connect.any_instance.stubs(:post).returns(failed_capture_response)
    params = {
        :transaction_type => { :value => 'capture'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => '123456'}
    }
    begin
      @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Capture Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
      assert_equal '550949', err.object['transaction_id'], err.object['transaction_id']
    end
  end

  def test_successful_refund
    Agms::Connect.any_instance.stubs(:post).returns(successful_sale_response)
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    Agms::Connect.any_instance.stubs(:post).returns(successful_refund_response)
    params = {
        :transaction_type => { :value => 'refund'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Refund Transaction Successful'
    assert_equal 'refund successful: Approved', response['response_message'], response['response_message']
    assert_equal '550946', response['transaction_id'], response['transaction_id']
  end

  def test_partial_refund
    Agms::Connect.any_instance.stubs(:post).returns(successful_sale_response)
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    Agms::Connect.any_instance.stubs(:post).returns(partial_refund_response)
    params = {
        :transaction_type => { :value => 'refund'},
        :amount => { :value => '5.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Refund Transaction Successful'
    assert_equal 'refund successful: Approved', response['response_message'], response['response_message']
    assert_equal '550946', response['transaction_id'], response['transaction_id']
  end

  def test_failed_refund
    Agms::Connect.any_instance.stubs(:post).returns(successful_sale_response)
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    @trans.process(params)
    Agms::Connect.any_instance.stubs(:post).returns(failed_refund_response)
    params = {
        :transaction_type => { :value => 'refund'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => '123456'}
    }
    begin
      @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Capture Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
      assert_equal '550953', err.object['transaction_id'], err.object['transaction_id']
    end
  end

  def test_successful_void
    Agms::Connect.any_instance.stubs(:post).returns(successful_sale_response)
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    Agms::Connect.any_instance.stubs(:post).returns(successful_void_response)
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Void Transaction Successful'
    assert_equal 'void successful: Approved', response['response_message'], response['response_message']
    assert_equal '550946', response['transaction_id'], response['transaction_id']
  end


  def test_failed_void
    Agms::Connect.any_instance.stubs(:post).returns(successful_sale_response)
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    @trans.process(params)
    Agms::Connect.any_instance.stubs(:post).returns(failed_void_response)
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => '123456'}
    }
    begin
      @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Void Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
      assert_equal '550953', err.object['transaction_id'], err.object['transaction_id']
    end
  end

  def test_successful_verify
    Agms::Connect.any_instance.stubs(:post).returns(successful_authorize_response)
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    Agms::Connect.any_instance.stubs(:post).returns(successful_void_response)
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Verify Transaction Successful'
    assert_equal 'void successful: Approved', response['response_message'], response['response_message']
    assert_equal '550946', response['transaction_id'], response['transaction_id']
  end


  def test_failed_verify
    Agms::Connect.any_instance.stubs(:post).returns(successful_authorize_response)
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    @trans.process(params)
    Agms::Connect.any_instance.stubs(:post).returns(failed_void_response)
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => '123456'}
    }
    begin
      @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Verify Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
      assert_equal '550953', err.object['transaction_id'], err.object['transaction_id']
    end
  end

  def successful_sale_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>Approved</STATUS_MSG><TRANS_ID>549865</TRANS_ID><AUTH_CODE>9999</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
    )
  end

  def failed_sale_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>2</STATUS_CODE><STATUS_MSG>Declined</STATUS_MSG><TRANS_ID>549879</TRANS_ID><AUTH_CODE>1234</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
    )
  end

  def successful_authorize_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>Approved</STATUS_MSG><TRANS_ID>550945</TRANS_ID><AUTH_CODE>9999</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>     )
  end

  def failed_authorize_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>2</STATUS_CODE><STATUS_MSG>Declined</STATUS_MSG><TRANS_ID>550941</TRANS_ID><AUTH_CODE>1234</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def successful_capture_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>Capture successful: Approved</STATUS_MSG><TRANS_ID>550946</TRANS_ID><AUTH_CODE>9999</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def partial_capture_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>Capture successful: Approved</STATUS_MSG><TRANS_ID>550946</TRANS_ID><AUTH_CODE>9999</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def failed_capture_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>10</STATUS_CODE><STATUS_MSG>Transaction ID is not valid. Please double check your Transaction ID</STATUS_MSG><TRANS_ID>550949</TRANS_ID><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def successful_refund_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>refund successful: Approved</STATUS_MSG><TRANS_ID>550946</TRANS_ID><AUTH_CODE>9999</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def partial_refund_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>refund successful: Approved</STATUS_MSG><TRANS_ID>550946</TRANS_ID><AUTH_CODE>9999</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def failed_refund_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>10</STATUS_CODE><STATUS_MSG>Transaction ID is not valid. Please double check your Transaction ID</STATUS_MSG><TRANS_ID>550953</TRANS_ID><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def successful_void_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>void successful: Approved</STATUS_MSG><TRANS_ID>550946</TRANS_ID><AUTH_CODE>9999</AUTH_CODE><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
     )
  end

  def failed_void_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>10</STATUS_CODE><STATUS_MSG>Transaction ID is not valid. Please double check your Transaction ID</STATUS_MSG><TRANS_ID>550953</TRANS_ID><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID>652</MERCHANT_ID><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end

  def invalid_login_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ProcessTransactionResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ProcessTransactionResult><STATUS_CODE>20</STATUS_CODE><STATUS_MSG>Authentication Failed</STATUS_MSG><TRANS_ID /><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID /><CUSTOMER_MESSAGE /><RRN /></ProcessTransactionResult></ProcessTransactionResponse></soap:Body></soap:Envelope>
      )
  end
end