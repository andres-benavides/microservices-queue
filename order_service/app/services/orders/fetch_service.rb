module Orders
  class FetchService
    def self.call(customer_id = nil)
      if customer_id.present?
        ::Order.where(customer_id: customer_id)
      else
        ::Order.all
      end
    end
  end
end
