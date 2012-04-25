class Donor < ActiveRecord::Base
  establish_connection :fundraiser_db

  has_many :donations
  has_many :fundraisers, :through => :donations
end
