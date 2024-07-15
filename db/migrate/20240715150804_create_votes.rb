class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.integer :external_identifier

      t.timestamps
    end
  end
end
