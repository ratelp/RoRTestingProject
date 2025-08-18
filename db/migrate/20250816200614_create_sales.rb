class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.integer :quantitaty
      t.decimal :total
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
