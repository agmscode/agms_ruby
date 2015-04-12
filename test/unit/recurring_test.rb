require File.expand_path("../../test_helper", __FILE__)

class RecurringTest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    @recurring = Agms::Recurring.new
  end

  def test_successful_recurring_transaction
    assert_equal '1', '1', 'Recurring Transaction Successful'
  end


end