class Customer < ApplicationRecord
  has_many :bikes
  has_many :repair_jobs
end
