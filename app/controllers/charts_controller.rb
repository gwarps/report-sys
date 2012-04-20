class ChartsController < ApplicationController

  before_filter :input_blank
  
  def input_blank
    if params[:s_date].eql?("")
      redirect_to root_path,:alert=>"Date Required"
    end
  end

  def index
    @action_name = params[:action_name]
  end

  def display_monthly
    @date_str = params[:s_date].split('-')
    @mon_data = Payment.month_data(@date_str[0].to_i,@date_str[1].to_i).to_a
  end

  def display_prvmonthly
    @date_str = params[:s_date].split('-')
    mon_data = Payment.month_prov_data(@date_str[0].to_i,@date_str[1].to_i).to_a
    prv_arr = Payment.month_date_data(@date_str)

    mon_data.each do |x|
      temp = prv_arr.select{|prv| prv.name_str.to_i.eql?(x.dc.to_i)}
      prv = temp.first
      prv.update_attributes(x)
    end

    @data_arr = prv_arr
  end
end
