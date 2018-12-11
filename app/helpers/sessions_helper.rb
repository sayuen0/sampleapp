module SessionsHelper
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
#ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:rememer_token] = user.remember_token
  end

#現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
#現在ログインしているユーザーを返す(いるなら)
  def current_user
    if(user_id = session[:user_id])
      @current_user ||= User.find_by(id:user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id:user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_uer = user
      end
    end
  end
#ユーザーがログインしていればtrueを返す
  def logged_in?
    !current_user.nil?
  end


end
