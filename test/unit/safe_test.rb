require File.expand_path("../../test_helper", __FILE__)

class SAFETest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    @safe = Agms::SAFE.new
  end

  def test_successful_SAFEAdd
    Agms::Connect.any_instance.stubs(:post).returns(successful_SAFEAdd_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '1', response['response_code'], 'SAFE Add Successful'
    assert_equal 'SAFE Record added successfully. No transaction processed.', response['response_message'], response['response_message']
    assert_equal '1035593', response['safe_id'], response['safe_id']
  end

  def test_failed_SAFEAdd
    Agms::Connect.any_instance.stubs(:post).returns(failed_SAFEAdd_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0500'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '1', response['response_code'], 'Sale Transaction Failed'
    assert_equal 'SAFE Record added successfully. No transaction processed.', response['response_message'], response['response_message']
    assert_equal '1035595', response['safe_id'], response['safe_id']
  end

  def test_successful_SAFEUpdate
    Agms::Connect.any_instance.stubs(:post).returns(successful_SAFEAdd_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '1', response['response_code'], 'Auth Transaction Successful'
    assert_equal 'SAFE Record added successfully. No transaction processed.', response['response_message'], response['response_message']
    safe_id = response['safe_id']
    Agms::Connect.any_instance.stubs(:post).returns(successful_SAFEUpdate_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'},
        :safe_id => { :value => safe_id}
    }
    response = @safe.update(params)
    assert_equal '1', response['response_code'], 'Auth Transaction Successful'
    assert_equal 'SAFE Record updated successfully. No transaction processed.', response['response_message'], response['response_message']
    assert_equal '1035596', response['safe_id'], response['safe_id']
  end

  def test_failed_SAFEUpdate
    Agms::Connect.any_instance.stubs(:post).returns(successful_SAFEAdd_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '1', response['response_code'], 'Auth Transaction Successful'
    assert_equal 'SAFE Record added successfully. No transaction processed.', response['response_message'], response['response_message']

    Agms::Connect.any_instance.stubs(:post).returns(failed_SAFEUpdate_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'},
        :safe_id => { :value => '123'}
    }
    begin
      @safe.update(params)
    rescue => err
      assert_equal '3', err.object['response_code'], 'Verify Transaction Failed'
      assert_equal 'SAFE Record failed to update successfully.  No transaction processed. ', err.object['response_message'], err.object['response_message']
      assert_equal '', err.object['safe_id'], err.object['safe_id']
    end

  end

  def test_successful_SAFEDelete
    Agms::Connect.any_instance.stubs(:post).returns(successful_SAFEAdd_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '1', response['response_code'], 'Auth Transaction Successful'
    assert_equal 'SAFE Record added successfully. No transaction processed.', response['response_message'], response['response_message']
    safe_id = response['safe_id']
    Agms::Connect.any_instance.stubs(:post).returns(successful_SAFEDelete_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'},
        :safe_id => { :value => safe_id}
    }
    response = @safe.delete(params)
    assert_equal '1', response['response_code'], 'Auth Transaction Successful'
    assert_equal 'SAFE record has been deactivated', response['response_message'], response['response_message']
  end



  def test_failed_SAFEDelete
    Agms::Connect.any_instance.stubs(:post).returns(successful_SAFEAdd_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '1', response['response_code'], 'Auth Transaction Successful'
    assert_equal 'SAFE Record added successfully. No transaction processed.', response['response_message'], response['response_message']
    Agms::Connect.any_instance.stubs(:post).returns(failed_SAFEDelete_response)
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'},
        :safe_id => { :value => '123'}
    }
    response = @safe.delete(params)
    assert_equal '2', response['response_code'], 'Verify Transaction Failed'
    assert_equal 'SAFE record failed to deactivate', response['response_message'], response['response_message']

  end

  def successful_SAFEAdd_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><AddToSAFEResponse xmlns=\"https://gateway.agms.com/roxapi/\"><AddToSAFEResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>SAFE Record added successfully. No transaction processed.</STATUS_MSG><TRANS_ID /><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID>1035593</SAFE_ID><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID /><CUSTOMER_MESSAGE /><RRN /></AddToSAFEResult></AddToSAFEResponse></soap:Body></soap:Envelope>
    )
  end

  def failed_SAFEAdd_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><AddToSAFEResponse xmlns=\"https://gateway.agms.com/roxapi/\"><AddToSAFEResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>SAFE Record added successfully. No transaction processed.</STATUS_MSG><TRANS_ID /><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID>1035595</SAFE_ID><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID /><CUSTOMER_MESSAGE /><RRN /></AddToSAFEResult></AddToSAFEResponse></soap:Body></soap:Envelope>
    )
  end

  def successful_SAFEUpdate_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><UpdateSAFEResponse xmlns=\"https://gateway.agms.com/roxapi/\"><UpdateSAFEResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>SAFE Record updated successfully. No transaction processed.</STATUS_MSG><TRANS_ID /><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID>1035596</SAFE_ID><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID /><CUSTOMER_MESSAGE /><RRN /></UpdateSAFEResult></UpdateSAFEResponse></soap:Body></soap:Envelope>
    )
  end

  def failed_SAFEUpdate_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><UpdateSAFEResponse xmlns=\"https://gateway.agms.com/roxapi/\"><UpdateSAFEResult><STATUS_CODE>3</STATUS_CODE><STATUS_MSG>SAFE Record failed to update successfully.  No transaction processed. </STATUS_MSG><TRANS_ID /><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID /><CUSTOMER_MESSAGE /><RRN /></UpdateSAFEResult></UpdateSAFEResponse></soap:Body></soap:Envelope>
    )
  end

  def successful_SAFEDelete_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><DeleteFromSAFEResponse xmlns=\"https://gateway.agms.com/roxapi/\"><DeleteFromSAFEResult><STATUS_CODE>1</STATUS_CODE><STATUS_MSG>SAFE record has been deactivated</STATUS_MSG><TRANS_ID /><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID /><CUSTOMER_MESSAGE /><RRN /></DeleteFromSAFEResult></DeleteFromSAFEResponse></soap:Body></soap:Envelope>
    )
  end

  def failed_SAFEDelete_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><DeleteFromSAFEResponse xmlns=\"https://gateway.agms.com/roxapi/\"><DeleteFromSAFEResult><STATUS_CODE>2</STATUS_CODE><STATUS_MSG>SAFE record failed to deactivate</STATUS_MSG><TRANS_ID /><AUTH_CODE /><AVS_CODE /><AVS_MSG /><CVV2_CODE /><CVV2_MSG /><ORDERID /><SAFE_ID /><FULLRESPONSE /><POSTSTRING /><BALANCE /><GIFTRESPONSE /><MERCHANT_ID /><CUSTOMER_MESSAGE /><RRN /></DeleteFromSAFEResult></DeleteFromSAFEResponse></soap:Body></soap:Envelope>
    )
  end

end