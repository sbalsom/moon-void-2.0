class AddAspectsToVoids < ActiveRecord::Migration[5.2]
  def change
    add_column :voids, :last_sep, :string
  end
end
