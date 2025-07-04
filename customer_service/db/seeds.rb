# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
Customer.create!([
  {
    id: "11111111-1111-1111-1111-111111111111",
    name: "Juan Pérez",
    address: "Calle Falsa 123, Bogotá",
    orders_count: 3
  },
  {
    name: "Ana Gómez",
    address: "Carrera 7 #45-67, Medellín",
    orders_count: 5
  },
  {
    name: "Carlos Rodríguez",
    address: "Av. Siempre Viva 742, Cali",
    orders_count: 1
  },
  {
    name: "Laura Méndez",
    address: "Transversal 23 #10-12, Barranquilla",
    orders_count: 0
  },
  {
    name: "Daniela Torres",
    address: "Diagonal 80 #22-35, Cartagena",
    orders_count: 2
  }
])