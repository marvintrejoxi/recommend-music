class WatsonPersonality < ApplicationRecord
  belongs_to :twitter_profile, class_name: 'TwitterProfile', optional: true
  has_many :last_fm_recommendations, class_name: 'LastFmRecommendation'

  scope :only_dominants, -> { where('score > 0.5') }
  scope :order_desc, -> { order(score: :desc) }
end
