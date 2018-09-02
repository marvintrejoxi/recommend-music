class TwitterProfilesController < ApplicationController

  respond_to :html

  helper_method :resource
  helper_method :personalities

  def create
    service = FetchTwitterProfile.new(params_resources[:username], resource)
    service.perfom!

    unless service.success?
      redirect_to root_path
    else
      respond_with resource, location: twitter_profile_path(service.twitter_profile.id)
    end
  end

  private

  def resource
    @resource ||=
      case action_name
      when 'new'
        TwitterProfile.new
      when 'create'
        # before creating, I verify if it already exists, if it exists, only update it
        TwitterProfile.where(username: params_resources[:username].capitalize).first_or_initialize
      when 'show'
        TwitterProfile.find(params[:id])
      end
  end

  def personalities
    @personalities ||= resource.try(:watson_personalities)
  end

  def params_resources
    params.require(:resource).permit(:username)
  end

end
