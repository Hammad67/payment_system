# frozen_string_literal: true

# user model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,:rememberable,:validatable,
         jwt_revocation_strategy: JwtDenylist
  has_one_attached :avatar
  enum type: {
    Admin: 0,
    Buyer: 1
  }
end
