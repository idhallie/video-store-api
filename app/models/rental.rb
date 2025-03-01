class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer
  
  def decrease_available
    if self.movie.available_inventory.nil?
      self.movie.available_inventory = self.movie.inventory - 1
      self.movie.save
      
      self.customer.movies_checked_out_count += 1
      self.customer.save
    else
      self.movie.available_inventory -= 1
      self.movie.save
      
      self.customer.movies_checked_out_count += 1
      self.customer.save
    end
  end
  
  def increase_available
    if self.checkout_date != nil
      if self.movie.available_inventory == nil
        return "This movie has not been returned yet"
      else
        self.movie.available_inventory += 1
        self.movie.save
        
        self.customer.movies_checked_out_count -= 1
        self.customer.save
      end
    end
  end
end
