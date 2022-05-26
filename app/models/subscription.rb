# frozen_string_literal: true

# subscription model
class Subscription < ApplicationRecord
  belongs_to :buyer
  belongs_to :plan
  has_many :transactions, dependent: :destroy
end
