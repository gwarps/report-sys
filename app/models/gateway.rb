class Gateway
  attr_accessor :name_str
  attr_accessor :offline, :paypal, :billbharo, :credits

  def initialize(name)
    @name_str = name
    @offline = 0
    @paypal = 0
    @credits = 0
    @billbharo = 0
  end

  def update_attributes(payment)
    gateway = payment.payment_gateway

    case gateway
    when nil
      self.offline = payment.count
    when "paypal"
      self.paypal = payment.count
    when "credit"
      self.credits = payment.count
    when "billbharo"
      self.billbharo = payment.count
    end
  end

end