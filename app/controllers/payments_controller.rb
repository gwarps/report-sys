class PaymentsController < ApplicationController
 
  def index
    # Setting Dates for Query
    prev_date = DatePick.prev_date
    cur_month_start,cur_month_end = DatePick.cur_month_date
    last_month_start,last_month_end = DatePick.last_month_date

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
   
    
    @u_count = u_data.first.count
    @u_total = u_data.first.total

    @gateway_list = Payment.gateway_list

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

    respond_to do |format|
      unless @date_pick.valid?
        flash.now[:alert] = @date_pick.errors.full_messages.first
        format.html{render 'payments/custom'}
      else
        @gateway_list = Payment.gateway_list
      
        custom_data = Payment.return_range(@date_pick.start_date,@date_pick.end_date)

        @gateway_list.each do |x|
          x.setc_payment(custom_data)
        end
      end
    end
  end
end
