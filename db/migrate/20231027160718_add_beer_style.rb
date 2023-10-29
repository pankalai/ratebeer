class AddBeerStyle < ActiveRecord::Migration[7.0]
  def change
    change_column :beers, :style, :string
  end
end
