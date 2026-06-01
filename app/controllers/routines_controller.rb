class RoutinesController < ApplicationController
  before_action :authenticate_user!

  def index
    @routines = current_user.routines
  end
end
