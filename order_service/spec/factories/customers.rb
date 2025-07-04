FactoryBot.define do
  factory :customer do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    address { Faker::Address.full_address }
    orders_count { 0 }
  end
end
