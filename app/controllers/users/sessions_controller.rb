# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def new_guest
      user = User.guest
      sign_in user
      redirect_to root_path, notice: t('header.guestmessage')
    end
  end
end