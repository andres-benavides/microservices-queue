namespace :orders do
  desc "Consume eventos de pedidos desde RabbitMQ"
  task consume: :environment do
    OrderEvents::ConsumeService.start
  end
end
