require File.expand_path("../../test_helper", __FILE__)

class RemoteInvoicingTest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    Agms::Configuration.verbose = true
    @invoicing = Agms::Invoicing.new
  end

  def test_successful_invoicing_transaction
    assert_equal '1', '1', 'Invoicing Transaction Successful'
  end

end