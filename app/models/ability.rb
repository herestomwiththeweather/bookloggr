# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :update, :destroy], Book, user: user
    can [:index, :home, :create], Book

    can [:read, :update, :destroy], Log, user: user
    can [:create], Log do |log|
      log.book.user_id == user.id
    end

    can [:read, :destroy], Post, user: user
    can [:create], Post do |post|
      post.book.user_id == user.id
    end
  end
end
