require 'factory_girl'

FactoryGirl.define do
  factory :twitter_user, aliases: [:author, :faver] do
  end

  factory :tweet do
    author 
    text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vehicula dapibus ullamcorper. Proin dignissim, massa vel venenatis massa nunc."
  end

  factory :fav do
    tweet
    faver
  end
end
