module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :admin?
  end

  class_methods do
    def admin_only(**options)
      before_action :require_admin, **options
    end
  end

  private
    def admin?
      Current.user&.admin?
    end

    def require_admin
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción." unless admin?
    end
end
