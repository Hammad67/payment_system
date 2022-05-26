# frozen_string_literal: true

# User Policy
class UserPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def index?
    @user.type == 'Admin'
  end

  def new?
    @user.type == 'Admin'
  end

  def create?
    @user.type == 'Admin'
  end

  def edit?
    @user.type == 'Admin'
  end

  def update?
    @user.type == 'Admin'
  end

  def destroy?
    @user.type == 'Admin'
  end

  def show?
    @user.type == 'Admin'
  end
end
