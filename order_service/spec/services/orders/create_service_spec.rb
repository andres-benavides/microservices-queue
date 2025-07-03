require 'rails_helper'

RSpec.describe Orders::CreateService, type: :service do
  let(:customer_id) { SecureRandom.uuid }

  before do
    stub_request(:get, "http://customer_service:3000/api/v1/customers/#{customer_id}")
      .to_return(
        status: 200,
        body: {
          id: customer_id,
          name: "Test Customer",
          address: "123 Main St",
          orders_count: 5
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it 'creates an order with client info' do
    params = {
      customer_id: customer_id,
      product_name: 'Keyboard',
      quantity: 1,
      price: 150.0,
      status: 'created'
    }

    order = Orders::CreateService.call(params)

    expect(order).to be_persisted
    expect(order.client_name).to eq('Test Customer')
    expect(order.client_address).to eq('123 Main St')
  end
end
