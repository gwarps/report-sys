class PaymentsController < ApplicationController
  def index
    prev_date = Date.today.prev_day
    
    cur_month_start = Date.new(Date.today.year,Date.today.month)
    cur_month_end = Date.today

    last_month_start = Date.new(Date.today.prev_month.year,Date.today.prev_month.month)
    # No subtraction with 1 TO manage complexity of datetime, so first date of next month
    # Now change in query for matching exact date with datetime
    last_month_end = cur_month_start - 1

    
    # -----------------------------------
    # For previous Date
    prev_date_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) = ?",prev_date]).group("payment_gateway").to_a
    # For Current Month
    cur_month_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) between ? and ?",cur_month_start,cur_month_end]).group("payment_gateway").to_a
    # For Last Month
    last_month_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) between ? and ?",last_month_start,last_month_end]).group("payment_gateway").to_a
    # Threshold Date for unknown
    thres_date = Payment.select("min(date(created_at)) as min_date").where(["payment_gateway in (?,?)","billbharo","paypal"]).to_a
    # Unknown status for min date for billbharo/paypal
    all_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) >= ?",thres_date.first.min_date]).group("payment_gateway").to_a

    u_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) < ?",thres_date.first.min_date]).group("payment_gateway").to_a
    payment_gate = Payment.select(:payment_gateway).uniq

    @actual_name = payment_gate.collect{|x| x.payment_gateway}
    #@gateway = payment_gate.collect{|x| (x.payment_gateway.nil?)? "Offline" : x.payment_gateway}

    @hash_prev_count = Hash[prev_date_data.map{|x| [x.payment_gateway,x.count]}]
    @hash_prev_total = Hash[prev_date_data.map{|x| [x.payment_gateway,x.total]}]

    @hash_cur_count = Hash[cur_month_data.map{|x| [x.payment_gateway,x.count]}]
    @hash_cur_total = Hash[cur_month_data.map{|x| [x.payment_gateway,x.total]}]

    @hash_last_count = Hash[last_month_data.map{|x| [x.payment_gateway,x.count]}]
    @hash_last_total = Hash[last_month_data.map{|x| [x.payment_gateway,x.total]}]
    
    @hash_all_count = Hash[all_data.map{|x| [x.payment_gateway ,x.count]}]
    @hash_all_total = Hash[all_data.map{|x| [x.payment_gateway,x.total]}]

    @u_count = u_data.first.count
    @u_total = u_data.first.total

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

  def custom_data
    # Setting Dates for Query
    prev_date = Date.today.prev_day
    cur_month_start = Date.new(Date.today.year,Date.today.month)
    cur_month_end = Date.today
    last_month_start = Date.new(Date.today.prev_month.year,Date.today.prev_month.month)
    # No subtraction with 1 TO manage complexity of datetime, so first date of next month
    # Now change in query for matching exact date with datetime
    last_month_end = cur_month_start - 1

    # For previous Date
    prev_date_data = Payment.return_single(prev_date)
    # For Current Month
    cur_month_data = Payment.return_range(cur_month_start,cur_month_end)
    # For Last Month
    last_month_data = Payment.return_range(last_month_start,last_month_end)
    # Threshold Date for unknown
    thres_date = Payment.threshold_date
    # Unknown status for min date for billbharo/paypal
    # If dont want threshold data, use nil as parameter
    all_data = Payment.return_all(thres_date)
    u_data = Payment.return_unk(thres_date)
   
    payment_gate = Payment.gateway_list

    @u_count = u_data.first.count
    @u_total = u_data.first.total

    @gateway_list = payment_gate.collect{|x| Provider.new(x.payment_gateway)}

    @gateway_list.each do |x|
      x.sety_payment(prev_date_data)
      x.setc_payment(cur_month_data)
      x.setl_payment(last_month_data)
      x.seta_payment(all_data)
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
      payment_gate = Payment.select(:payment_gateway).uniq
      @actual_name = payment_gate.collect{|x| x.payment_gateway}
      
      custom_data = Payment.select("payment_gateway,count(*) as count,sum(amount) as total").where(["date(created_at) between ? and ?",@date_pick.start_date,@date_pick.end_date]).group("payment_gateway").to_a

      @hash_count = Hash[custom_data.map{|x| [x.payment_gateway,x.count]}]
      @hash_total = Hash[custom_data.map{|x| [x.payment_gateway,x.total]}]


      @actual_name.each do |pmt|
        @hash_count[pmt] = 0 if !@hash_count.keys.include?(pmt)
        @hash_total[pmt] = 0 if !@hash_total.keys.include?(pmt)
      end
    end
  end
end
