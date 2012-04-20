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

  # Lenders Query for Google charts
  # ===============================

  def self.month_data(d_month,d_year)
    data = Payment.select("count(*) as count,day(date(created_at)) as dc").where(["month(date(created_at)) = ? and year(date(created_at)) =?",d_month,d_year]).group("dc").to_a
    return data
  end

  def self.month_prov_data(d_month,d_year)
    data = Payment.select("count(*) as count,day(date(created_at)) as dc, payment_gateway").where(["month(date(created_at)) = ? and year(date(created_at)) =?",d_month,d_year]).group("dc,payment_gateway").to_a
    return data
  end

  def self.month_date_data(date_str)
    date_start = Date.new(date_str[1].to_i,date_str[0].to_i)
    date_end = (date_start >> 1) - 1

    prv_arr = []
    date_start.day.upto(date_end.day){|number|
      prv = Gateway.new("#{number}")
      prv_arr << prv
    }
    return prv_arr
  end
  

end
