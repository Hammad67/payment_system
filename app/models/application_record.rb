# frozen_string_literal: true

# base class of active record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
