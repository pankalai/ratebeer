class SessionsController < ApplicationController
  def new
    # Renderöi kirjautumissivun
  end

  def create
    # Haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]

    if user.closed
      return redirect_to signin_path, notice: "Your account is closed, please contact with admin"
    end

    # Talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # Nollataan sessio
    session[:user_id] = nil
    # Uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
