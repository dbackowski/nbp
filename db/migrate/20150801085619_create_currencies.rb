class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name, null: false
      t.integer :converter, null: false
      t.string :code, null: false
      t.float :buy_price, null: false
      t.float :sell_price, null: false

      t.references :exchange, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
