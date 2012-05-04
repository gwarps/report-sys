class OfferCouponUsersController < ApplicationController
  def index
    
  end

  def display_range
    @date_pick = DatePick.new(:start_date => params[:start_date], :end_date => params[:end_date])
    
    respond_to do |format|
      if @date_pick.valid?
        @redeems = OfferCouponUser.return_range(@date_pick.start_date,@date_pick.end_date)
        format.html{render "offer_coupon_users/display_range"}
      else
        flash.now[:error] = @date_pick.errors.full_messages.first
        format.html{render :action => "index"}
      end
    end
  end
end
