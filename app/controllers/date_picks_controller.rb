class DatePicksController < ApplicationController

  def index
    redirect_to new_date_pick_path
  end
  def new
    @date_pick = DatePick.new(:start_date => params[:start_date], :end_date => params[:end_date])
  end

  def create
    @date_pick = DatePick.new(params[:date_pick])
    respond_to do |format|
      if @date_pick.valid?

        @gateway_list = Payment.gateway_list
        custom_data = Payment.return_range(@date_pick.start_date,@date_pick.end_date)

        @gateway_list.each do |x|
          x.setc_payment(custom_data)
        end
        format.html{render 'payments/execute_custom'}
        
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @date_pick.errors, :status => :unprocessable_entity }

      end
    end
  end
end
