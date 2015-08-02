class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :name, null: false
      t.date :quotation_date, null: false
      t.date :publication_date, null: false

      t.timestamps null: false
    end
  end
end
