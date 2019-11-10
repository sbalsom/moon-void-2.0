class CreateAspects < ActiveRecord::Migration[5.2]
  def change
    create_table :aspects do |t|
      t.datetime :begin_void
      t.datetime :end_void
      t.timestamps
      t.integer :degree
      t.string :formatted_degree
      t.string :planet
      t.string :formatted_planet
    end
  end
end
