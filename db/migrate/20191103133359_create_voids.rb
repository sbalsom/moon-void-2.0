class CreateVoids < ActiveRecord::Migration[5.2]
  def change
    create_table :voids do |t|
      t.datetime :begin
      t.datetime :end
      t.string :begin_sign
      t.string :end_sign

      t.timestamps
    end
  end
end
