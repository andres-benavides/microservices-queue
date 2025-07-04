require 'rails_helper'
require 'net/http'
require 'json'

RSpec.describe 'Order to Customer integration', type: :request do
  let(:customer_id) { SecureRandom.uuid }

  def create_customer(customer_id)
    uri = URI("http://customer_service:3000/api/v1/customers")
    response = Net::HTTP.post(
      uri,
      {
        customer: {
          id: customer_id,
          name: "Test User",
          address: "123 Testing Street",
          age: 30
        }
      }.to_json,
      { "Content-Type" => "application/json" }
    )
    expect(response.code).to eq("201")
  end

  def create_order(customer_id, product = "Test Product")
    uri = URI("http://order_service:3000/api/v1/orders")
    Net::HTTP.post(
      uri,
      {
        order: {
          customer_id: customer_id,
          product_name: product,
          quantity: 1,
          price: 10.5,
          status: "created"
        }
      }.to_json,
      { "Content-Type" => "application/json" }
    )
  end

  def fetch_customer(customer_id)
    uri = URI("http://customer_service:3000/api/v1/customers/#{customer_id}")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body) if response.code == "200"
  end

  it 'receives order event and updates orders_count' do
    create_customer(customer_id)
    response = create_order(customer_id)

    expect(response.code).to eq("201")
    sleep 3

    data = fetch_customer(customer_id)
    expect(data["orders_count"]).to eq(1)
  end

  it 'returns 422 if customer does not exist' do
    response = create_order("non-existent-id")
    expect(response.code).to eq("422")
  end

  it 'increments orders_count with multiple orders' do
    create_customer(customer_id)

    3.times do |i|
      response = create_order(customer_id, "Product #{i}")
      expect(response.code).to eq("201")
    end

    sleep 3

    data = fetch_customer(customer_id)
    expect(data["orders_count"]).to eq(3)
  end

end
