class OfferCouponsController < ApplicationController
  def index
    @offer_coupons = OfferCoupon.all
  end
  def show
    @offer_coupon = OfferCoupon.find(params[:id])
  end
end
