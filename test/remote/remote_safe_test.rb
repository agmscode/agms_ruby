require File.expand_path("../../test_helper", __FILE__)

class RemoteSAFETest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    # Agms::Configuration.verbose = true
    @safe = Agms::SAFE.new
  end

  def test_successful_SAFEAdd
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0520'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '1', response['response_code'], 'Sale Transaction Successful'
    assert_equal 'SAFE Record added successfully. No transaction processed.', response['response_message'], response['response_message']
  end

  def test_failed_SAFEAdd
    params = {
        :payment_type => { :value => 'creditcard'},
        :first_name => { :value => 'Joe'},
        :last_name => { :value => 'Smith'},
        :cc_number => { :value => '4111111111111111'},
        :cc_exp_date => { :value => '0500'},
        :cc_cvv => { :value => '123'}
    }
    response = @safe.add(params)
    assert_equal '2', response['response_code'], 'Sale Transaction Failed'
    assert_equal 'Declined', response['response_message'], response['response_message']
  end

  def test_successful_SAFEUpdate
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
  end

  def test_failed_SAFEUpdate
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
      response = @safe.update(params)
    rescue => err
      assert_equal '3', err.object['response_code'], 'Verify Transaction Failed'
      assert_equal 'SAFE Record failed to update successfully.  No transaction processed. ', err.object['response_message'], err.object['response_message']
    end
  end

  def test_successful_SAFEDelete
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

end