  require 'bunny'

  module OrderEvents
    class ConsumeService
      def self.start
        connection = Bunny.new(hostname: ENV['RABBITMQ_HOST'] || 'localhost')
        connection.start

        channel = connection.create_channel
        queue = channel.queue('order_events', durable: true)
        exchange = channel.direct('orders_exchange', durable: true)
        queue.bind(exchange, routing_key: 'order.created')

        Rails.logger.info("Waiting for messages in the queue 'order_events'...")

        queue.subscribe(block: true, manual_ack: true) do |delivery_info, _properties, payload|
          begin
            data = JSON.parse(payload)
            Rails.logger.info("Message arrived: #{data}")
            customer = Customer.find_by(id: data["customer_id"])
              
            if customer
              customer.increment!(:orders_count)
              Rails.logger.info("orders_count update for #{customer.name}")
            else
              Rails.logger.warn("Costumer not found ID: #{data["customer_id"]}")
            end
            

            channel.ack(delivery_info.delivery_tag)
          rescue => e
            Rails.logger.error("Error processing message: #{e.message}")
            raise e
          end
        end
      end
    end
  end
