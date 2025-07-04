require 'rails_helper'

RSpec.describe OrderEvents::ConsumeService, type: :service do
  describe '.start' do
    let(:channel) { instance_double(Bunny::Channel) }
    let(:queue) { instance_double(Bunny::Queue) }
    let(:exchange) { instance_double(Bunny::Exchange) }
    let(:connection) { instance_double(Bunny::Session) }

    let(:customer) { create(:customer) }

    let(:message_payload) {
      {
        order_id: SecureRandom.uuid,
        customer_id: customer.id,
        status: 'created'
      }.to_json
    }

    before do
      allow(Bunny).to receive(:new).and_return(connection)
      allow(connection).to receive(:start)
      allow(connection).to receive(:create_channel).and_return(channel)
      allow(channel).to receive(:queue).with('order_events', durable: true).and_return(queue)
      allow(channel).to receive(:direct).with('orders_exchange', durable: true).and_return(exchange)
      allow(queue).to receive(:bind).with(exchange, routing_key: 'order.created')
    end

    it 'increments orders_count for the customer when a valid message is received' do
      allow(queue).to receive(:subscribe).with(block: true, manual_ack: true)
        .and_yield(double(delivery_tag: 'tag123'), nil, message_payload)

      allow(channel).to receive(:ack).with('tag123')

      expect {
        Timeout.timeout(1) { described_class.start }
      }.to change { customer.reload.orders_count }.by(1)
    end

    it 'logs a warning if the customer is not found' do
      payload = {
        order_id: SecureRandom.uuid,
        customer_id: SecureRandom.uuid, # no existe
        status: 'created'
      }.to_json

      allow(queue).to receive(:subscribe).with(block: true, manual_ack: true)
        .and_yield(double(delivery_tag: 'tag456'), nil, payload)

      allow(channel).to receive(:ack).with('tag456')

      expect(Rails.logger).to receive(:warn).with(/Costumer not found/)
      expect {
        Timeout.timeout(1) { described_class.start }
      }.not_to change { Customer.count }
    end

    it 'logs and raises error when message processing fails' do
      bad_payload = 'this_is_not_json'

      allow(queue).to receive(:subscribe).with(block: true, manual_ack: true)
        .and_yield(double(delivery_tag: 'tag789'), nil, bad_payload)

      expect(Rails.logger).to receive(:error).with(/Error processing message/)
      expect {
        Timeout.timeout(1) { described_class.start }
      }.to raise_error(JSON::ParserError)
    end
  end
end
