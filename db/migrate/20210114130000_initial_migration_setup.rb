class InitialMigrationSetup < ActiveRecord::Migration[6.1]
  def change
    create_enum :user_roles, %w[admin supplier]

    create_table :users do |t|
      t.string :email
      t.string :source_id
      t.enum :role, enum_name: :user_roles

      t.timestamps
    end

    create_table :suppliers do |t|
      t.string :name, null: false
      t.string :unique_reference_number

      t.timestamps
    end

    create_table :supplier_members do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :supplier, index: true, foreign_key: true
    end

    create_table :products do |t|
      t.belongs_to :supplier, null: false, foreign_key: true
      t.string :name
      t.date :start_at
      t.date :end_at
      t.integer :quantity
      t.integer :unit_cost

      t.integer :availability
      t.integer :total_value

      t.datetime :approved_at
      t.references :approved_by, foreign_key: {to_table: :users}

      t.timestamps
    end

    create_table :product_items do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.string :name

      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
