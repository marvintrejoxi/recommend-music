class TwitterProfile < ApplicationRecord
  has_many :watson_personalities, class_name: 'WatsonPersonality'

  validates :username, presence: true, uniqueness: true
end
