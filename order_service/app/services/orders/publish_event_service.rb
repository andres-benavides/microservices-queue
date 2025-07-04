require 'bunny'

module Orders
  class PublishEventService
    def self.call(order)
      connection = Bunny.new(hostname: ENV['RABBITMQ_HOST'] || 'localhost')
      connection.start

      channel = connection.create_channel
      exchange = channel.direct('orders_exchange', durable: true)

      message = {
        order_id: order.id,
        customer_id: order.customer_id,
        status: order.status
      }.to_json

      exchange.publish(
        message,
        routing_key: 'order.created',
        content_type: 'application/json'
      )

      Rails.logger.info("Event published in RabbitMQ: #{message}")

      connection.close
    rescue => e
      Rails.logger.error("Error published messagge in RabbitMQ: #{e.message}")
      raise e
    end
  end
end
