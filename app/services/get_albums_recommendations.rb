class GetAlbumsRecommendations

  attr_accessor :twitter_profile
  attr_accessor :watson_personalities
  attr_accessor :resources
  attr_accessor :instance
  attr_accessor :response

  def initialize twitter_profile
    self.twitter_profile = twitter_profile
    self.watson_personalities = twitter_profile.try(:watson_personalities).only_dominants.order_desc.limit(3)
    self.resources = []
  end

  def perfom!
    assign_resources
    get_last_fm_album!
  end

  def last_fm_config
    @last_fm_config ||= OpenStruct.new(YAML::load(File.open("#{Rails.root.to_s}/config/settings.yml"))["last_fm"])
  end

  def assign_resources
    watson_personalities.each do |watson_personality|
      genres = variants_per_personalities[watson_personality.try(:name)]
      next unless genres
      resources << { watson_personality_id: watson_personality.try(:id), genres: genres }
    end
  end

  def get_last_fm_album!
    begin
      resources.each do |resource|
        resource[:genres].each do |tag|
          default_params[:tag] = tag
          self.instance = RestClient::Resource.new([base_uri, default_params.to_query].join('?'))
          self.response = instance.get

          create_last_fm_recommendation(response, resource[:watson_personality_id], tag)
        end
      end
    rescue Exception
      nil
    end
  end

  def create_last_fm_recommendation response, watson_personality_id, tag
    recommendations = JSON.parse(response.body)['albums']['album']
    recommendations.each do |recommendation|
      params_recomendation =
        {
          watson_personality_id: watson_personality_id,
          album_name: recommendation['name'],
          album_url: recommendation['url'],
          artist_name: recommendation['artist']['name'],
          artist_url: recommendation['artist']['url'],
          album_image: recommendation['image'][3],
          genre: tag
        }
      LastFmRecommendation.create(params_recomendation)
    end
  end

  def base_uri
    @base_uri ||= 'http://ws.audioscrobbler.com/2.0/'
  end

  def default_params
    @default_params ||=
      {
        api_key: last_fm_config.api_key,
        format: 'json',
        method: 'tag.gettopalbums',
        tag: '',
        limit: 3
      }.with_indifferent_access
  end

  def variants_per_personalities
    @variants_per_personalities ||=
      {
        'Openness':
          [
            'classical',
            'blues',
            'jazz',
            'folk'
          ],
        'Extraversion':
          [
            'rap',
            'hip hop',
            'soul',
            'electronic',
            'dance'
          ],
        'Agreeableness':
          [
            'upbeat'
          ],
        'Neuroticism':
          [
            'country',
            'pop'
          ],
        'Conscientiousness':
          [
            'dance',
            'jazz',
            'electronic',
            'hip hop',
            'rap',
            'pop'
          ]
      }.with_indifferent_access
  end

end
