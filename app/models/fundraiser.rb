class Fundraiser < ActiveRecord::Base
  establish_connection :fundraiser_db

  has_many :donations
  has_many :donors, :through => :donations

  def return_yest_count
    s_date = DatePick.prev_date
    return self.donations.where(["date(created_at) = ?",s_date]).count
  end

  def return_current_month_count
    s_date,e_date = DatePick.cur_month_date
    return self.donations.where(["date(created_at) between ? and ?",s_date,e_date]).count
  end

  def return_last_month_count
    s_date,e_date = DatePick.last_month_date
    return self.donations.where(["date(created_at) between ? and ?",s_date,e_date]).count
  end 
  
  def return_all_count
    return self.donations.count
  end

  def inr_amount
    currency = self.currency
    amount=0
    case currency
    when "USD"
      amount = self.collected_amount * self.usd_to_inr.to_f
    when "SGD"
      amount = self.collected_amount * self.sgd_to_inr.to_f
    when "INR"
      amount = self.collected_amount
    end

    return amount
  end

  def return_yest_amount
    s_date = DatePick.prev_date
    donation = self.donations.where(["date(created_at) = ?",s_date])
    if donation.any?
      amt = 0.00
      donation.each do |donate|
        amt = amt + donate.get_inr_amount
      end
      return amt
    else
      return 0.00
    end
  end

  def return_current_month_amount
    s_date,e_date = DatePick.cur_month_date
    donation = self.donations.where(["date(created_at) between ? and ?",s_date,e_date])
    if donation.any?
      amt = 0.00
      donation.each do |donate|
        amt = amt + donate.get_inr_amount
      end
      return amt
    else
      return 0.00
    end
  end

  def return_last_month_amount
    s_date,e_date = DatePick.last_month_date
    donation = self.donations.where(["date(created_at) between ? and ?",s_date,e_date])
    if donation.any?
      amt = 0.00
      donation.each do |donate|
        amt = amt + donate.get_inr_amount
      end
      return amt
    else
      return 0.00
    end
  end

  def identifier_name
    return "Campaign #{self.id} #{self.identifier.capitalize}"
  end
  def self.return_total_amount
    camp = Fundraiser.all
    amt = 0.00

    camp.each do |fundraiser|
      case fundraiser.currency
      when "USD"
        amt = amt + fundraiser.collected_amount * 50
      when "SGD"
        amt = amt + fundraiser.collected_amount * 40
      when "INR"
        amt = amt + fundraiser.collected_amount
      end
    end

    return amt;
  end
end
