require File.expand_path("../../test_helper", __FILE__)

class RemoteTransactionTest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    # Agms::Configuration.verbose = true
    @trans = Agms::Transaction.new
  end

  def test_successful_sale
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
  end

  def test_failed_sale
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
  end

  def test_successful_authorize
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
  end

  def test_failed_authorize
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
  end

  def test_successful_capture
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'capture'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Capture Transaction Successful'
    assert_equal 'Capture successful: Approved', response['response_message'], response['response_message']
  end

  def test_partial_capture
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'capture'},
        :amount => { :value => '5.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Capture Transaction Successful'
    assert_equal 'Capture successful: Approved', response['response_message'], response['response_message']
  end

  def test_failed_capture
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'capture'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => '123456'}
    }
    begin
      response = @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Capture Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
    end
  end

  def test_successful_refund
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'refund'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Refund Transaction Successful'
    assert_equal 'refund successful: Approved', response['response_message'], response['response_message']
  end

  def test_partial_refund
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'refund'},
        :amount => { :value => '5.00'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Refund Transaction Successful'
    assert_equal 'refund successful: Approved', response['response_message'], response['response_message']
  end

  def test_failed_refund
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'refund'},
        :amount => { :value => '10.00'},
        :transaction_id => { :value => '123456'}
    }
    begin
      response = @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Capture Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
    end
  end

  def test_successful_void
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Void Transaction Successful'
    assert_equal 'void successful: Approved', response['response_message'], response['response_message']
  end


  def test_failed_void
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => '123456'}
    }
    begin
      response = @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Void Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
    end
  end

  def test_successful_verify
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => transaction_id}
    }
    response = @trans.process(params)
    assert_equal '1', response['response_code'], 'Verify Transaction Successful'
    assert_equal 'void successful: Approved', response['response_message'], response['response_message']
  end


  def test_failed_verify
    params = {
        :transaction_type => { :value => 'auth'},
        :amount => { :value => '10.00'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @trans.process(params)
    transaction_id = response['transaction_id']
    params = {
        :transaction_type => { :value => 'void'},
        :transaction_id => { :value => '123456'}
    }
    begin
      response = @trans.process(params)
    rescue => err
      assert_equal '10', err.object['response_code'], 'Verify Transaction Failed'
      assert_equal 'Transaction ID is not valid. Please double check your Transaction ID', err.object['response_message'], err.object['response_message']
    end
  end
end