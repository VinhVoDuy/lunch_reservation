class ApiController < ActionController::Base
  before_action :doorkeeper_authorize!

  def current_user
    @current_user ||= User.find_by_id(doorkeeper_token[:resource_owner_id]) if doorkeeper_token.present?
  end
end
