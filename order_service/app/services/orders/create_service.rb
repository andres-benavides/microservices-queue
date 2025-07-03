module Orders
  class CreateService
    def self.call(params)
      customer_id = params[:customer_id]
      customer = Customers::CustomerClient.get_customer(customer_id)
      order = nil
      raise "Customer not found" unless customer
        ActiveRecord::Base.transaction do
        order = ::Order.create!(
          customer_id: customer_id,
          product_name: params[:product_name],
          quantity: params[:quantity],
          price: params[:price],
          status: params[:status],
          client_name: customer["name"],
          client_address: customer["address"]
        )
        Orders::PublishEventService.call(order)
      end
      order
    end
  end
end
