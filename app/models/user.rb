class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :user_restrictions, dependent: :destroy
  has_many :restrictions, through: :user_restrictions
  has_many :friendships, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :bio, presence: true

  def add_friend(email_address)
    new_friend = User.where(email: email_address).first
    return false if new_friend.nil?
    Friendship.create!(user_id: self.id, friend_id: new_friend.id)
    Friendship.create!(user_id: new_friend.id, friend_id: self.id)
    return true
  end

  def load_friends
    friendships.map do |friend|
      User.find(friend.friend_id)
    end
  end
end
