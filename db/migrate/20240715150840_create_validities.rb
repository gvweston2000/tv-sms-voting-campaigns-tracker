class CreateValidities < ActiveRecord::Migration[7.1]
  def change
    create_table :validities do |t|
      t.string :measure

      t.timestamps
    end
  end
end
