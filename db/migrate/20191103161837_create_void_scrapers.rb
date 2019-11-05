class CreateVoidScrapers < ActiveRecord::Migration[5.2]
  def change
    create_table :void_scrapers do |t|

      t.timestamps
    end
  end
end
