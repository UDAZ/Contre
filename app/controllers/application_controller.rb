# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  
  protected
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  def set_locale
    I18n.locale = session[:locale] if %w[ja en].include?(session[:locale])
  end
end
