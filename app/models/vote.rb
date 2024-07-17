class Vote < ApplicationRecord
    belongs_to :candidate
    belongs_to :validity

    validates :external_identifier, presence: true
end
