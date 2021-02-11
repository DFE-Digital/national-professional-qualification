class AASMCreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table(:orders) do |t|
      t.belongs_to :product
      t.belongs_to :product_item
      t.string :teacher_reference_number
      t.string :state
      t.integer :price_pence, default: 0
      t.integer :amount_paid_pence, default: 0
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps null: false 
    end

    create_table(:statement_orders) do |t|
      t.belongs_to :statement
      t.belongs_to :order
    end

    add_column :products, :state, :string
  end
end
