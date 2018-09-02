class FetchTwitterProfile

  attr_accessor :username
  attr_accessor :success
  attr_accessor :twitter_profile

  def initialize username, twitter_profile
    self.username = username
    self.success = false
    self.twitter_profile = twitter_profile
  end

  def success?
    success
  end

  def perfom!
    create_profile!
  end

  def twitter_config
    @twitter_config ||= OpenStruct.new(YAML::load(File.open("#{Rails.root.to_s}/config/settings.yml"))["twitter"])
  end

  def instance
    @instance ||= Twitter::REST::Client.new do |config|
      config.consumer_key = twitter_config.consumer_key
      config.consumer_secret = twitter_config.consumer_secret
      config.access_token = twitter_config.access_token
      config.access_token_secret = twitter_config.access_token_secret
    end
  end

  def create_profile!
    begin
      user = instance.user(username)

      user_params =
        {
          name: user.name,
          username: user.screen_name,
          user_id: user.id,
          location: user.location,
          language: user.lang,
          image_path: user.profile_image_url_https,
          description: user.description
        }

      twitter_profile.assign_attributes user_params
      twitter_profile.save

      self.success = true
      GetWatsonPersonalities.new(instance, twitter_profile).perfom!
    rescue Twitter::Error::NotFound

    end
  end

end
