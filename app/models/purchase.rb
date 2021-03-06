class Purchase < ActiveRecord::Base
  has_many :payments, dependent: :destroy
  belongs_to :user
  validates :title, presence: true
  validates :min_price, presence: true, :numericality => {:greater_than => 0}
  validates :current_total_price, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :deadline, presence: true
  validates :user_id, presence:true
  validates :group, presence: true
  attr_accessible :title, :description, :min_price, :deadline, :group, :current_total_price, :user_id

  def get_remaining_price()
    remaining = self.min_price - self.current_total_price
    if remaining < 0
      return 0
    else
      return remaining
    end
  end

  def get_current_user_payment(current_user)
    user_payment = nil
    for payment in self.payments
      if payment.user_id == current_user.id
        user_payment = payment
      end
    end
    return user_payment
  end

  def update_current_total_price()
    total = 0
    for payment in self.payments
      total = total + payment.price
    end
    self.current_total_price = total
    if total >= self.min_price
      self.state = 2
    else
      self.state = 1
    end
    self.save
    return
  end
  
  # Enums for state
  MINIMUM_NOT_MET = 1
  MINIMUM_MET = 2
  CONFIRMED = 3
  CHARGED = 4
  
  def is_minimum_not_met?
    return self.state == MINIMUM_NOT_MET
  end
  
  def is_minimum_met?
    return self.state == MINIMUM_MET
  end
  
  def is_closed?
    return self.state == CONFIRMED
  end
  
  def is_finalized?
    return self.state == CHARGED
  end
  
  def is_accepting_payments?
    return self.is_minimum_met? || self.is_minimum_not_met?
  end
end
