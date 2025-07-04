FactoryBot.define do
  factory :order do
    customer_id { SecureRandom.uuid }
    product_name { Faker::Commerce.product_name }
    quantity { rand(1..5) }
    price { Faker::Commerce.price(range: 10.0..100.0) }
    status { 'created' }
    client_name { Faker::Name.name }
    client_address { Faker::Address.full_address }
  end
end
