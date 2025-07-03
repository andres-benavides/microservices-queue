class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    
    create_table :customers, id: :uuid do |t|
      t.string :name
      t.text :address
      t.integer :orders_count
      t.integer :age

      t.timestamps
    end
  end
end
