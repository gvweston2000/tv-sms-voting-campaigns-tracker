class CreateCampaignsCandidates < ActiveRecord::Migration[7.1]
  def change
    create_table :campaigns_candidates, id: false do |t|
      t.belongs_to :campaign
      t.belongs_to :candidate
    end
  end
end
