class AddBeerStyleNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column :beers, :style, :string, :default => "IPA", :null => false
  end
end
