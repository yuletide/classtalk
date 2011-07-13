RailsAdmin.authenticate_with do
  redirect_to new_admin_session_path unless current_admin && current_admin.email == "admin@codeforamerica.org"
end
