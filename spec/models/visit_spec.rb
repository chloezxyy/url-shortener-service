require 'rails_helper'

class VisitTest < ActiveSupport::TestCase
  def setup
    @visit = Visit.new(ip_address: '192.168.1.1', geolocation: 'New York, USA', url_id: 1)
  end

  test "should be valid with valid attributes" do
    assert @visit.valid?
  end

  test "should be invalid without ip_address" do
    @visit.ip_address = nil
    assert_not @visit.valid?
    assert_includes @visit.errors[:ip_address], "can't be blank"
  end

  test "should be invalid without geolocation" do
    @visit.geolocation = nil
    assert_not @visit.valid?
    assert_includes @visit.errors[:geolocation], "can't be blank"
  end
end
