class PaymentsController < ApplicationController
  def index
    prev_date_start = Date.today.prev_day
    prev_date_end = prev_date_start + 1
    
    cur_month_start = Date.new(Date.today.year,Date.today.month)
    cur_month_end = prev_date_end

    last_month_start = Date.new(Date.today.prev_month.year,Date.today.prev_month.month)
    # No subtraction with 1 TO manage complexity of datetime, so first date of next month
    last_month_end = Date.new(Date.today.year,Date.today.month)

    prev_date_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(:created_at => prev_date_start..prev_date_end).group("payment_gateway").to_a

    cur_month_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(:created_at => cur_month_start..cur_month_end).group("payment_gateway").to_a

    last_month_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(:created_at => last_month_start..last_month_end).group("payment_gateway").to_a

    all_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").group("payment_gateway").to_a

    payment_gate = Payment.select(:payment_gateway).uniq
    @actual_name = payment_gate.collect{|x| x.payment_gateway}
    #@gateway = payment_gate.collect{|x| (x.payment_gateway.nil?)? "Offline" : x.payment_gateway}

    @hash_prev_count = Hash[prev_date_data.map{|x| [x.payment_gateway,x.count]}]
    @hash_prev_total = Hash[prev_date_data.map{|x| [x.payment_gateway,x.total]}]

    @hash_cur_count = Hash[cur_month_data.map{|x| [x.payment_gateway,x.count]}]
    @hash_cur_total = Hash[cur_month_data.map{|x| [x.payment_gateway,x.total]}]

    @hash_last_count = Hash[last_month_data.map{|x| [x.payment_gateway,x.count]}]
    @hash_last_total = Hash[last_month_data.map{|x| [x.payment_gateway,x.total]}]
    
    @hash_all_count = Hash[all_data.map{|x| [x.payment_gateway,x.count]}]
    @hash_all_total = Hash[all_data.map{|x| [x.payment_gateway,x.total]}]
    
    @actual_name.each do |pmt|
      @hash_prev_count[pmt] = 0 if !@hash_prev_count.keys.include?(pmt)
      @hash_prev_total[pmt] = 0 if !@hash_prev_total.keys.include?(pmt)

      @hash_cur_count[pmt] = 0 if !@hash_cur_count.keys.include?(pmt)
      @hash_cur_total[pmt] = 0 if !@hash_cur_total.keys.include?(pmt)

      @hash_last_count[pmt] = 0 if !@hash_last_count.keys.include?(pmt)
      @hash_last_total[pmt] = 0 if !@hash_last_total.keys.include?(pmt)

      @hash_all_count[pmt] = 0 if !@hash_all_count.keys.include?(pmt)
      @hash_all_total[pmt] = 0 if !@hash_all_total.keys.include?(pmt)
    end

   
  end

  def custom
  end

  def execute_custom
    @date_pick = DatePick.new
    @date_pick.start_date = params[:start_date]
    @date_pick.end_date = params[:end_date]

 
    unless @date_pick.valid?
      flash.now[:error] = @date_pick.errors.full_messages.first
    else
      start_date = Date.strptime(params[:start_date],"%Y/%m/%d")
      end_date = Date.strptime(params[:end_date],"%Y/%m/%d") + 1

      payment_gate = Payment.select(:payment_gateway).uniq
      @actual_name = payment_gate.collect{|x| x.payment_gateway}
      
      custom_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(:created_at => start_date..end_date).group("payment_gateway").to_a

      @hash_count = Hash[custom_data.map{|x| [x.payment_gateway,x.count]}]
      @hash_total = Hash[custom_data.map{|x| [x.payment_gateway,x.total]}]


      @actual_name.each do |pmt|
        @hash_count[pmt] = 0 if !@hash_count.keys.include?(pmt)
        @hash_total[pmt] = 0 if !@hash_total.keys.include?(pmt)
      end
    end
  end
end
