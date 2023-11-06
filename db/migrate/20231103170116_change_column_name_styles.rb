class ChangeColumnNameStyles < ActiveRecord::Migration[7.0]
  def change
    rename_column(:beers, :style, :old_style)
    add_column :beers, :style_id, :integer
    add_foreign_key :beers, :styles, column: :style_id, primary_key: :id
  end
end
