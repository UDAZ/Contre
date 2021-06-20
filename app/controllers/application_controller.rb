class ApplicationController < ActionController::Base
  before_action :set_locale

  private
    def set_locale
      if %w(ja en).include?(session[:locale])
        I18n.locale = session[:locale]
      end
    end
end
