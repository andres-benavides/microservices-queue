class Order < ApplicationRecord
  enum status: { created: 0, progress: 1, finish: 2 }

  validates :customer_id, :product_name, :quantity, :price, :status, presence: true

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :created
  end
end
