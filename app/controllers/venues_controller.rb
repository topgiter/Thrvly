class VenuesController < ApplicationController
  layout "venues_faq", only: [:faq]
  layout "venues_index", only: [:index]

  def faq
  end

  def index
  end
end
