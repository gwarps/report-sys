class OfferCoupon < ActiveRecord::Base
  has_many :redeems, :class_name => "OfferCouponUser"
end
