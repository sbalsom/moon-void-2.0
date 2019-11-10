class AddApectForeignKeyToVoids < ActiveRecord::Migration[5.2]
  def change
    add_reference :voids, :aspect, foreign_key: true
  end
end
