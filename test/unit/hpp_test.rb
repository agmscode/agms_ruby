require File.expand_path("../../test_helper", __FILE__)

class ReportTest < Test::Unit::TestCase
  def setup
    config = YAML::load(File.open(File.expand_path("../../fixtures.yml", __FILE__)))['agms']
    Agms::Configuration.configure(
        config['login'],
        config['password'],
        config['account_number'],
        config['api_key']
    )
    @hpp = Agms::HPP.new
  end

  def test_successful_HPPGetHash
    Agms::Connect.any_instance.stubs(:post).returns(successful_HPPGetHash_response)
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
    assert_equal 'wZZaqjttCWc9oy/hby3pD7IwYzLJ3oSo80HFylbOJkQ%3D', response['hash'], response['hash']
  end

  def test_successful_HPPGetLink
    Agms::Connect.any_instance.stubs(:post).returns(successful_HPPGetHash_response)
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
    assert_equal 'Hash', response.class.name, 'HPP Transaction Successful'
    assert_equal 'wZZaqjttCWc9oy/hby3pD7IwYzLJ3oSo80HFylbOJkQ%3D', response['hash'], response['hash']
    assert_equal 'https://gateway.agms.com/HostedPaymentForm/HostedPaymentPage.aspx?hash=wZZaqjttCWc9oy/hby3pD7IwYzLJ3oSo80HFylbOJkQ%3D', link, link
  end

  def successful_HPPGetHash_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ReturnHostedPaymentSetupResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ReturnHostedPaymentSetupResult>wZZaqjttCWc9oy/hby3pD7IwYzLJ3oSo80HFylbOJkQ%3D</ReturnHostedPaymentSetupResult></ReturnHostedPaymentSetupResponse></soap:Body></soap:Envelope>
    )
  end

  def successful_HPPGetLink_response
    %(
<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><ReturnHostedPaymentSetupResponse xmlns=\"https://gateway.agms.com/roxapi/\"><ReturnHostedPaymentSetupResult>wZZaqjttCWc9oy/hby3pD7IwYzLJ3oSo80HFylbOJkQ%3D</ReturnHostedPaymentSetupResult></ReturnHostedPaymentSetupResponse></soap:Body></soap:Envelope>
    )
  end
end