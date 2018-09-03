class GetWatsonPersonalities

  attr_accessor :twitter_instance
  attr_accessor :twitter_profile
  attr_accessor :params
  attr_accessor :response
  attr_accessor :personalities

  def initialize twitter_instance, twitter_profile
    self.twitter_instance = twitter_instance
    self.twitter_profile = twitter_profile
    self.params = { contentItems: [] }
  end

  def perfom!
    assign_params
    watson_personalities
    create_twitter_profile_personalities!
  end

  def instance
    @instance ||= RestClient::Resource.new(base_uri, user: watson_config.user, password: watson_config.password, headers: headers)
  end

  def watson_personalities
    begin
      self.response = instance.post(params.to_json, content_type: "application/json")
      self.personalities = JSON.parse(response).with_indifferent_access
    rescue Exception => e

    end
  end

  def valid_personalities
    @valid_personalities ||=
      unless personalities.blank?
        personalities[:personality].select{ |personality| personality[:raw_score] > 0.5 }
      else
        []
      end
  end

  def watson_default_personalities
    @watson_default_personalities ||=
      [
        {
          name: 'Activity level',
          category: 'personality',
          percentage: 0.8,
          score: 0.8,
          significant: true,
          trait_id: 'facet_activity_level'
        },
        {
          name: 'Gregariousness',
          category: 'personality',
          percentage: 0.7,
          score: 0.7,
          significant: true,
          trait_id: 'facet_friendliness'
        },
        {
          name: 'Agreeableness',
          category: 'personality',
          percentage: 0.6,
          score: 0.6,
          significant: true,
          trait_id: 'big5_agreeableness'
        }
      ]
  end

  def create_twitter_profile_personalities!
    create_personalities =
      case
      when !valid_personalities.blank?
        valid_personalities.map do |personality|
          {
            name: personality[:name],
            category: personality[:category],
            percentage: personality[:percentile],
            score: personality[:raw_score],
            significant: personality[:significant],
            trait_id: personality[:trait_id]
          }
        end
      else
        watson_default_personalities
      end
    twitter_profile.watson_personalities.create(create_personalities)
  end

  def watson_config
    @watson_config ||= OpenStruct.new(YAML::load(File.open("#{Rails.root.to_s}/config/settings.yml"))["watson"])
  end

  def headers
    @headers ||=
      {
        "Accept" => "application/json"
      }
  end

  def base_uri
    @base_uri ||= "https://gateway.watsonplatform.net/personality-insights/api/v3/profile?version=2017-10-13&consumption_preferences=true&raw_scores=true"
  end

  def user_tweets
    user_tweets ||= twitter_instance.user_timeline(twitter_profile.username, count: watson_config.number_of_tweets)
  end


  def assign_params
    unless user_tweets.blank?
      user_tweets.each do |tweet|
        params[:contentItems] <<
          {
            contenttype: "text/plain",
            content: tweet.text,
            language: tweet.lang
          }
      end
    end
    params[:contentItems]
  end
end
