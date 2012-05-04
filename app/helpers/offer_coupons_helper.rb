module OfferCouponsHelper
  def status_helper(exp_datetime)
    expire_date = exp_datetime.to_date
    today_date = Date.today
    
    if(expire_date > today_date)
      days_left = (expire_date - today_date).to_i
      return "<span style=\"color:green;\">Available (#{days_left} days left)</span>"
    else
      return "<span style=\"color:red;\">Expired</span>"
    end
  end

end
