require File.expand_path("../../test_helper", __FILE__)

class AgmsTest < Test::Unit::TestCase
  def setup
  end

  def test_library_version
    assert_equal '0.1.3', Agms::Agms.getLibraryVersion, 'Agms Library Version Successful'
  end

  def test_api_version
    assert_equal '3', Agms::Agms.getAPIVersion, 'Agms Library Version Successful'
  end

  def test_whatCardType
    card_trunc = '345'
    assert_equal 'American Express', Agms::Agms.whatCardType(card_trunc), 'What Card Type Successful'
    assert_equal 'AX', Agms::Agms.whatCardType(card_trunc, 'abbreviation'), 'What Card Type Successful'
  end
end

