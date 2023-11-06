class UpdateBeerStyleIdsCaseFix < ActiveRecord::Migration[7.0]
  def change
    execute %Q(
        UPDATE beers
        SET style_id = (SELECT id FROM styles WHERE lower(name)=lower(beers.old_style))
    )
  end
end
