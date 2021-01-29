class DashboardController < ApplicationController
  include HTTPAuth
  before_action :require_user!

  def index
  end
end
