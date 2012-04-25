class FundraisersController < ApplicationController
  def index
    @fundraisers = Fundraiser.order("id")
  end

  
end
