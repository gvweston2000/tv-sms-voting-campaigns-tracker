class Campaign < ApplicationRecord
    has_many :campaign_candidates
    has_many :candidates, through: :campaign_candidates
    has_many :votes, through: :candidates

    validates :episode, presence: true, uniqueness: true
end
