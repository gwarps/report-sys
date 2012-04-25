class Donation < ActiveRecord::Base
  establish_connection :fundraiser_db

  belongs_to :fundraiser
  belongs_to :donor

  def get_inr_amount
    amt = 0

    case self.currency
    when "USD"
      amt = amt + self.amount * 50
    when "SGD"
      amt = amt + self.amount * 40
    when "INR"
      amt = amt + self.amount
    end

    return amt
  end

  def self.total_yest_count
    s_date = DatePick.prev_date
    return Donation.where(["date(created_at) = ?",s_date]).count
  end

  def self.total_current_month_count
    s_date,e_date = DatePick.cur_month_date
    return Donation.where(["date(created_at) between ? and ?",s_date,e_date]).count
  end

  def self.total_last_month_count
    s_date,e_date = DatePick.last_month_date
    return Donation.where(["date(created_at) between ? and ?",s_date,e_date]).count
  end

  def self.total_all_count
    return Donation.count
  end

  def self.total_yest_amount
    s_date = DatePick.prev_date
    donation = Donation.where(["date(created_at) = ?",s_date])

    amt = 0.00
    donation.each do |donate|
      amt = amt + donate.get_inr_amount
    end

    return amt
  end

  def self.total_current_month_amount
    s_date,e_date = DatePick.cur_month_date

    donation = Donation.where(["date(created_at) between ? and ?",s_date,e_date])

    amt = 0.00
    donation.each do |donate|
      amt = amt + donate.get_inr_amount
    end

    return amt
  end

  def self.total_last_month_amount
    s_date,e_date = DatePick.last_month_date

    donation = Donation.where(["date(created_at) between ? and ?",s_date,e_date])

    amt = 0.00
    donation.each do |donate|
      amt = amt + donate.get_inr_amount
    end

    return amt
  end
end
