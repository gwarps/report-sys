class FundraisersController < ApplicationController
  def index
    @fundraisers = Fundraiser.order("id")
  end

  def fundraiser_select
    @fundraisers = Fundraiser.order("id")
  end

  def fundraiser_redirect
    @fundraiser = Fundraiser.find(params[:id])
    respond_to do |format|
      format.html{redirect_to(@fundraiser)}
      format.json{render :json => @fundraiser}
    end
  end
  def show
    @fundraiser = Fundraiser.find(params[:id])

    respond_to do |format|
      format.html
      format.json{render :json => @fundraiser}
    end
  end
  
end
