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
end