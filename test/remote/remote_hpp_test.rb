require File.expand_path("../../test_helper", __FILE__)

class RemoteHPPTest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    Agms::Configuration.verbose = true
    @hpp = Agms::HPP.new
  end

  def test_successful_HPPGetHash
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '20.00'},
        :first_name => { :setting => 'required'},
        :last_name => { :setting => 'required'},
        :zip => { :setting => 'required'},
        :email => { :setting => 'required'},
        :hpp_format => { :value => '1'}
    }
    response = @hpp.generate(params)
    assert_equal 'Hash', response.class.name, 'HPP Transaction Successful'
  end

  def test_successful_HPPGetLink
    params = {
        :transaction_type => { :value => 'sale'},
        :amount => { :value => '20.00'},
        :first_name => { :setting => 'required'},
        :last_name => { :setting => 'required'},
        :zip => { :setting => 'required'},
        :email => { :setting => 'required'},
        :hpp_format => { :value => '1'}
    }
    response = @hpp.generate(params)
    link = @hpp.getLink
    assert_equal 'Hash', response.class.name, 'Report SAFE API Successful'
    assert_equal 'String', link.class.name, 'Report SAFE API Successful'
  end
end