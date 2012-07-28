require 'spec_helper'

describe Fav do
  it 'should respond to "faver"' do
  	fav = Fav.new
  	fav.should respond_to :faver
  end
end

# == Schema Information
#
# Table name: favs
#
#  id         :integer          not null, primary key
#  tweet_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faver_id   :integer
#

