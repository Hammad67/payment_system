# frozen_string_literal: true

class Admin < User
  has_many :plans
end
