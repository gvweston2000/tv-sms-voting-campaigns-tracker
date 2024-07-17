class CampaignCandidate < ApplicationRecord
  belongs_to :candidate
  belongs_to :campaign

  self.table_name = "campaigns_candidates"
end