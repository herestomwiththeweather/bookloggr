# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :update], Book, user: user
    can [:index, :home, :create], Book

    can [:read, :update, :destroy], Log, user: user
    can [:create], Log do |log|
      log.book.user_id == user.id
    end
  end
end
