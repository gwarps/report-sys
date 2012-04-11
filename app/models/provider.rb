 class Provider

   attr_accessor :gateway
   attr_accessor :y_count,:c_count,:l_count,:a_count
   attr_accessor :y_total,:c_total,:l_total,:a_total
  def initialize(name)
    @gateway = name

    @y_count = 0
    @c_count = 0
    @l_count = 0
    @a_count = 0

    @y_total = 0.00
    @c_total = 0.00
    @l_total = 0.00
    @a_total = 0.00
  end

  def sety_payment  (gate_data)
    gate_data.each do |x|
      if self.gateway == x.payment_gateway
        self.y_count = x.count
        self.y_total = x.total
      end
    end
  end

  def setc_payment  (gate_data)
    gate_data.each do |x|
      if self.gateway == x.payment_gateway
        self.c_count = x.count
        self.c_total = x.total
      end
    end
  end

  def setl_payment  (gate_data)
    gate_data.each do |x|
      if self.gateway == x.payment_gateway
        self.l_count = x.count
        self.l_total = x.total
      end
    end
  end

  def seta_payment  (gate_data)
    gate_data.each do |x|
      if self.gateway == x.payment_gateway
        self.a_count = x.count
        self.a_total = x.total
      end
    end
  end
  
end