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
          orders_count: 3
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe '.call' do
    it 'creates an order with customer data' do
      params = attributes_for(:order).merge(customer_id: customer_id)

      order = described_class.call(params)

      expect(order).to be_persisted
      expect(order.client_name).to eq("Test Customer")
      expect(order.client_address).to eq("123 Main St")
    end

    context 'when customer is not found (404)' do
      before do
        stub_request(:get, "http://customer_service:3000/api/v1/customers/#{customer_id}")
          .to_return(status: 404)
      end

      it 'raises an error' do
        params = attributes_for(:order).merge(customer_id: customer_id)

        expect {
          described_class.call(params)
        }.to raise_error("Customer not found")
      end
    end

    context 'when request to customer service fails' do
      before do
        stub_request(:get, "http://customer_service:3000/api/v1/customers/#{customer_id}")
          .to_timeout
      end

      it 'raises an error' do
        params = attributes_for(:order).merge(customer_id: customer_id)

        expect {
          described_class.call(params)
        }.to raise_error("Customer not found")
      end
    end
  end
end
