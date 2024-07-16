class Validity < ApplicationRecord
    has_many :votes

    def pre_measure?
        measure == 'pre'
    end

    def during_measure?
        measure == 'during'
    end

    def post_measure?
        measure == 'post'
    end
end
