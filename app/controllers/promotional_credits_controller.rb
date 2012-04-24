class PromotionalCreditsController < ApplicationController
  def index
    @credits = PromotionalCredit.order("user_id")
  end
end
