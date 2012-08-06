require 'mock_twitter_api'

describe MockTwitterApi do
  before do
    @api = MockTwitterApi.new
  end
  it "should provide favs for a user" do
    current_favs = @api.get_favs("1234")
  end
  it "should provide info for a user" do
    fresh_info = @api.get_user_info("1234")
    fresh_info.screen_name.should match("1234")
    fresh_info.profile_image_url.should match("1234.jpg")
  end
end
