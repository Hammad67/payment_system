# frozen_string_literal: true

# Subscription Policy
class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    @user.type == 'Admin'
  end

  def new?
    @user.type == 'Buyer'
  end

  def create?
    @user.type == 'Buyer'
  end

  def edit?
    @user.type == 'Buyer'
  end

  def update?
    @user.type == 'Buyer'
  end

  def destroy?
    @user.type == 'Buyer'
  end

  def show?
    @user.type == 'Buyer'
  end
end
