class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  # Redirect after sign in
  def after_sign_in_path_for(resource)
    characters_path
  end

  # Redirect after sign out
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
