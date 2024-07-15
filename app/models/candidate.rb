class Candidate < ApplicationRecord
    has_and_belongs_to_many :campaigns

    has_many :votes
end
