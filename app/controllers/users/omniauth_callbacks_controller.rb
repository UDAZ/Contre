# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      @user = User.find_for_github_oauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
      else
        session['devise.github_data'] = request.env['omniauth.auth']
        redirect_to root_path
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
