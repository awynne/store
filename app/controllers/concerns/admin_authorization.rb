module AdminAuthorization
  extend ActiveSupport::Concern

  private

  def require_admin
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: "Access denied. Admin privileges required."
    end
  end

  def admin_or_redirect
    require_admin
  end
end
