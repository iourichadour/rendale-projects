require "#{File.dirname(__FILE__)}/abstract_unit"

class FirebirdConnectionTest < ActiveSupport::TestCase
  def test_charset_properly_set
    fb_conn = ActiveRecord::Base.connection.instance_variable_get(:@connection)
    assert_equal 'UTF8', fb_conn.database.character_set
  end
end
