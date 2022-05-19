# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :buyer
  belongs_to :plan
  has_many :transactions # rubocop:todo Rails/HasManyOrHasOneDependent
end
