class WatsonPersonality < ApplicationRecord
  belongs_to :twitter_profile, class_name: 'TwitterProfile', optional: true
end
