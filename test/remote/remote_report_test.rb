require File.expand_path("../../test_helper", __FILE__)

class RemoteReportTest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    Agms::Configuration.verbose = true
    @report = Agms::Report.new
  end

  def test_successful_TransactionAPI
    params = {
        :start_date => { :value => '2015-03-25'},
        :end_date => { :value => '2015-03-31'}
    }
    response = @report.listTransactions(params)
    assert_equal 'Array', response.class.name, 'Report Transaction API Successful'

  end

  def test_successful_SAFEAPI
    params = {
        :start_date => { :value => '2015-03-25'},
        :end_date => { :value => '2015-03-31'}
    }
    response = @report.listSAFEs(params)
    assert_equal 'Array', response.class.name, 'Report SAFE API Successful'
  end
end