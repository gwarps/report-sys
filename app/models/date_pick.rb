class DatePick
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :start_date,:end_date

  def start_must_be_less_then_end
    errors.add(:start_date, "must be less then end") unless
    self.start_date < self.end_date
  end

  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates_format_of :start_date, :with => /\d{4}\/\d{2}\/\d{2}/
  validates_format_of :end_date, :with => /\d{4}\/\d{2}\/\d{2}/
  validate :start_must_be_less_then_end

  def self.prev_date
    Date.today.prev_day
  end

  def self.cur_month_date
    cur_month_start = Date.new(Date.today.year,Date.today.month)
    cur_month_end = Date.today

    return cur_month_start,cur_month_end
  end

  def self.last_month_date
    last_month_start = Date.new(Date.today.prev_month.year,Date.today.prev_month.month)
    last_month_end = Date.new(Date.today.year,Date.today.month) - 1

    return last_month_start,last_month_end
  end

end