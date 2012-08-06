require 'mock_twitter_api'

describe MockTwitterApi do
  before do
    @api = MockTwitterApi.new
  end
  it "should provide 20 favs by default" do
    current_favs = @api.get_favs("1234")
    current_favs.should have(20).items
  end
  it "should provide as many favs as desired" do
    NUM_DESIRED = 42
    current_favs = @api.get_favs("1234", count=NUM_DESIRED)
    current_favs.should have(NUM_DESIRED).items
  end
  it "should provide info for a user" do
    fresh_info = @api.get_user_info("1234")
    fresh_info.screen_name.should match("1234")
    fresh_info.profile_image_url.should match("1234.jpg")
  end
end
