class OfferCouponUser < ActiveRecord::Base
  belongs_to :offer_coupon
  belongs_to :user

  def self.return_range(s_date,e_date)
    return OfferCouponUser.select("id,offer_coupon_id,user_id,issued_at,created_at").where(["date(created_at) between ? and ?",s_date,e_date])
  end
end
