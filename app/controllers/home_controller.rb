class HomeController < ApplicationController

  skip_before_filter :authenticate,:only => "index"
  def index
  end
end
