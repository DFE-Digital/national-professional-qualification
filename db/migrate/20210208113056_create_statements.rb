class CreateStatements < ActiveRecord::Migration[6.1]
  def change
    create_table :statements do |t|
      t.monetize :amount
      t.date :scheduled_at
      t.string :reason
      t.belongs_to :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
