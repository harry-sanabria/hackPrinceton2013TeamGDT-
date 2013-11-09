class Purchase < ActiveRecord::Base
  has_many :payments, dependent: :destroy
  has_many :users, :through => :payments
  validates :title, presence: true
  validates :price, presence: true, :numericality => {:greater_than => 0}
  attr_accessible :title, :price

  def how_much_due(user_payment)
    total = 0
    for payment in self.payments
      total += payment.part
    end
    return (self.price.to_f*(user_payment.part.to_f/total)).round(2)
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

  def get_total_parts_except_user(current_user)
    total = 0
    for payment in self.payments
      if payment.user.id != current_user.id
        total += payment.part
      end
    end
    return total
  end
end
