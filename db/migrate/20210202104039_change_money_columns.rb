class ChangeMoneyColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :unit_cost
    remove_column :products, :total_value
    add_monetize :products, :price, currency: { present: false }, amount: { null: true, default: 0 }
    add_monetize :products, :total_value, currency: { present: false }, amount: { null: true, default: 0 }
  end
end
