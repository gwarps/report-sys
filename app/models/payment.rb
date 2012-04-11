class Payment < ActiveRecord::Base

  def self.return_single(s_date)
    return Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) =?",s_date]).group("payment_gateway").to_a
  end

  def self.return_range(s_date,e_date)
    return Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) between ? and ?",s_date,e_date]).group("payment_gateway").to_a
  end
end
