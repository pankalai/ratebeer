class AddBeerStyleNotNullNoDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :beers, :style, :string, :null => false
  end
end
