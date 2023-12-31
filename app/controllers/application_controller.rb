class ApplicationController < ActionController::Base
  # Määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user
  helper_method :admin_user

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def admin_user
    return false if session[:user_id].nil?

    !User.find(session[:user_id]).admin.nil?
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'You should be signed in' if current_user.nil?
  end

  def clear_brewery_cache
    expire_fragment('brewerylist')
  end
end
