# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer] do |updatable|
      user.author?(updatable)
    end
    can :destroy, [Question, Answer], user_id: user.id
    can :add_comment, [Question, Answer]

    can %i[vote_up vote_down], [Question, Answer] do |votable|
      !user.author?(votable)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can :destroy, Link, linkable: { user_id: user.id }

    can :best, Answer, question: { user_id: user.id }

    can :me, User
  end
end
