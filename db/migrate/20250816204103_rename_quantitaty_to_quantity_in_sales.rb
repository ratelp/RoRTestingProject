class RenameQuantitatyToQuantityInSales < ActiveRecord::Migration[8.0]
  def change
    rename_column :sales, :quantitaty, :quantity
  end
end

