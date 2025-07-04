require 'rails_helper'

RSpec.describe Orders::PublishEventService, type: :service do
  let(:order) { create(:order) }

  describe '.call' do
    context 'when RabbitMQ is available' do
      it 'publishes the message successfully' do
        # 🔧 Mocks de todos los objetos necesarios
        connection = instance_double(Bunny::Session)
        channel = instance_double(Bunny::Channel)
        exchange = instance_double(Bunny::Exchange)
        queue = instance_double(Bunny::Queue)

        allow(Bunny).to receive(:new).and_return(connection)
        allow(connection).to receive(:start)
        allow(connection).to receive(:create_channel).and_return(channel)
        allow(channel).to receive(:queue).and_return(queue)
        allow(channel).to receive(:direct).and_return(exchange)
        allow(exchange).to receive(:publish)
        allow(connection).to receive(:close)

        expect {
          described_class.call(order)
        }.not_to raise_error

        expect(exchange).to have_received(:publish).once
      end
    end

    context 'when RabbitMQ is not reachable' do
      it 'raises Bunny::TCPConnectionFailed' do
        allow(Bunny).to receive(:new).and_raise(Bunny::TCPConnectionFailed.new('Connection failed'))

        expect {
          described_class.call(order)
        }.to raise_error(Bunny::TCPConnectionFailed)
      end
    end

    context 'when an unknown Bunny error occurs' do
      it 'raises the error' do
        allow(Bunny).to receive(:new).and_raise(StandardError.new("Unexpected error"))

        expect {
          described_class.call(order)
        }.to raise_error(StandardError, /Unexpected error/)
      end
    end
  end
end
