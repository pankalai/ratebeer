class EditForeignKeyBeerStyle < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :beers, :styles
    add_foreign_key :beers, :styles, column: :style_id, primary_key: :id, on_delete: :nullify
  end
end
