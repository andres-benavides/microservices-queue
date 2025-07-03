class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders, id: :uuid do |t|
      t.uuid :customer_id
      t.string :product_name
      t.integer :quantity
      t.decimal :price
      t.integer :status
      t.string :client_name
      t.text :client_address

      t.timestamps
    end
  end
end
