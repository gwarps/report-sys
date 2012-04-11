class Payment < ActiveRecord::Base

  def self.return_single(s_date)
    return Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) =?",s_date]).group("payment_gateway").to_a
  end

  def self.return_range(s_date,e_date)
    return Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) between ? and ?",s_date,e_date]).group("payment_gateway").to_a
  end

  def self.return_all(thres_date)
    if thres_date.nil?
      return Payment.select("payment_gateway,count(*) as count,sum(amount) as total").group("payment_gateway")
    else
      return Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) >= ?",thres_date]).group("payment_gateway").to_a
    end
  end

  def self.return_unk(thres_date)
    return Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) < ?",thres_date]).group("payment_gateway").to_a
  end
  
  def self.threshold_date
    th_date = Payment.select("min(date(created_at)) as min_date").where(["payment_gateway in (?,?)","billbharo","paypal"]).to_a
    return th_date.first.min_date
  end

  def self.gateway_list
    payment_gate = Payment.select(:payment_gateway).uniq
    gateway_obj = payment_gate.collect{|x| Provider.new(x.payment_gateway)}
    return gateway_obj
  end

end
