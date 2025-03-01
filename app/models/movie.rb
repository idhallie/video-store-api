class Movie < ApplicationRecord
  has_many :rentals, :dependent => :nullify
  
  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :inventory, presence: true, numericality: {only_integer: true}
  
end
