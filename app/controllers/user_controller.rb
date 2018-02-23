class UserController < ApplicationController
  before_action :require_login, only: [:new]
  
  def index
  end

  def edit
  end

  def show
  end
end
