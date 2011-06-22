class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :only=>[:edit,:update,:destroy,:edit_password]
  def edit_password
  end
end
