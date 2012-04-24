class User < ActiveRecord::Base
  has_one :facebook_info
  has_one :promotional_credit

  def full_name
    if self.first_name.nil?
      if self.facebook_info.nil?
        return "No Records"
      else
        self.facebook_info.first_name.capitalize + " " + self.facebook_info.last_name.capitalize
      end
    else
      return self.first_name.capitalize + " " + self.last_name.capitalize
    end
  end
end
