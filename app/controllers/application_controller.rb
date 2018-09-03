class ApplicationController < ActionController::Base
  helper_method :twitter_profiles

  private

  def twitter_profiles
    @twitter_profiles ||= TwitterProfile.all
  end
end
