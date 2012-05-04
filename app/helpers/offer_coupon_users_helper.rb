module OfferCouponUsersHelper
  def time_zone_india_helper(utc_datetime)
    indian_time = utc_datetime.in_time_zone("Asia/Kolkata")
    return indian_time
  end

  def user_name_helper(user_id)
    if User.exists?(user_id)
      user = User.find(user_id)
      return user.full_name
    else
      return "NOT EXIST"
    end
  end

  def user_email_helper(user_id)
    if User.exists?(user_id)
      user = User.find(user_id)
      return user.email
    else
      return "NOT EXIST"
    end
  end

  def offer_coupon_code_helper(offer_coupon_id)
    if OfferCoupon.exists?(offer_coupon_id)
      oc  = OfferCoupon.find(offer_coupon_id)
      return oc.code
    else
      return "Not Exist"
    end
  end
end