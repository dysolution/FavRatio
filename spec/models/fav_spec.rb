# == Schema Information
#
# Table name: favs
#
#  id         :integer         not null, primary key
#  tweet_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  faver_id   :integer
#

require 'spec_helper'

describe Fav do
  pending "add some examples to (or delete) #{__FILE__}"
end
