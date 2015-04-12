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

end

