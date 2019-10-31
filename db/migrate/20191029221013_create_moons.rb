class CreateMoons < ActiveRecord::Migration[5.2]
  def change
    create_table :moons do |t|
      t.boolean :void
      t.boolean :ingressed
      t.date :date
      t.integer :utc_offset
      t.string :sign
      t.string :next_sign
      t.date :next_ingress

      t.timestamps
    end
  end
end
