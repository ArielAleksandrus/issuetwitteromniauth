class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], env["omniauth.params"], current_api_v1_user)
        if @user.persisted?
          redirect_to '/api/v1/users/' + @user.slug + "?token=" + @user.app.api_token.token
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to '/'
        end
      end
    }
  end

  [:twitter].each do |provider|
    provides_callback_for provider
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
end
