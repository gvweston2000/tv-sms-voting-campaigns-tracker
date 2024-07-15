class AddValidityRefToVotes < ActiveRecord::Migration[7.1]
  def change
    add_reference :votes, :validity, null: false, foreign_key: true
  end
end
