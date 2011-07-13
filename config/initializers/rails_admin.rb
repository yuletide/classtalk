RailsAdmin.authenticate_with do
  redirect_to root_path unless current_admin && current_admin.email == "admin@codeforamerica.org"
end
