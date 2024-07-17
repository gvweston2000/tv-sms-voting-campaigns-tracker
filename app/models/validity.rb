class Validity < ApplicationRecord
    has_many :votes

    validates :measure, presence: true, uniqueness: true

    def pre_measure?
        measure == 'Pre'
    end

    def during_measure?
        measure == 'During'
    end

    def post_measure?
        measure == 'Post'
    end
end
