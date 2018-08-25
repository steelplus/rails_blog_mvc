class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:home]

  def index
    # サインインしている場合はホーム画面にリダイレクト
    if user_signed_in?
      redirect_to :action => 'home'
    end
  end

  def home
  end
end
