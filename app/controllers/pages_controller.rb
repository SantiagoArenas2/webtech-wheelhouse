class PagesController < ApplicationController
  def home
  end

  def services
    @services = [
      { name: "Safety check", price: 15 },
      { name: "Brake adjustment", price: 20 },
      { name: "Gear adjustment", price: 25 },
      { name: "Puncture repair", price: 18 },
      { name: "Tube replacement", price: 22 },
      { name: "Chain replacement", price: 30 },
      { name: "Cassette replacement", price: 45 },
      { name: "Brake pad replacement", price: 28 },
      { name: "Wheel truing", price: 35 },
      { name: "Bottom bracket service", price: 50 },
      { name: "Full service", price: 85 },
      { name: "Bike assembly", price: 70 }
    ]
  end

  def visit
  end

  def about
  end
end