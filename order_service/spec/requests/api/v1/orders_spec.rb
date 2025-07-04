require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  describe 'GET /api/v1/orders' do
    let(:customer_id) { SecureRandom.uuid }
    let(:other_customer_id) { SecureRandom.uuid }

    context 'when customer has multiple orders' do
      before do
        create_list(:order, 3, customer_id: customer_id)
      end

      it 'returns all orders for the given customer' do
        get "/api/v1/orders", params: { customer_id: customer_id }

        expect(response).to have_http_status(:ok)
        orders = JSON.parse(response.body)
        expect(orders.size).to eq(3)
        expect(orders.all? { |o| o["customer_id"] == customer_id }).to be true
      end
    end

    context 'when customer has no orders' do
      it 'returns an empty array' do
        get "/api/v1/orders", params: { customer_id: customer_id }

        expect(response).to have_http_status(:ok)
        orders = JSON.parse(response.body)
        expect(orders).to eq([])
      end
    end

    context 'when no customer_id is provided' do
      before do
        create(:order, customer_id: customer_id)
        create(:order, customer_id: other_customer_id)
      end

      it 'returns all orders for all customers' do
        get "/api/v1/orders"

        expect(response).to have_http_status(:ok)
        orders = JSON.parse(response.body)
        expect(orders.size).to eq(2)
      end
    end
  end
end
