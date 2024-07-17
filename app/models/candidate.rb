class Candidate < ApplicationRecord
    has_many :campaign_candidates
    has_many :campaigns, through: :campaign_candidates
    has_many :votes

    validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z]+\z/, :message => "is not valid." }
end
