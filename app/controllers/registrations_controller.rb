class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :only=>[:edit,:update,:destroy,:edit_password, :dont_show_again]
  def edit_password
  end
  
  def dont_show_again
    current_user.update_attribute(:show_group_number_popup, false)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {"ok".to_json}
    end
  end
  
end
