# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def new_guest
      user = User.guest
      sign_in user
      redirect_to user_path(user), notice: t('header.guestmessage')
    end
  end
end