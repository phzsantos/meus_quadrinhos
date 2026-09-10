# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable

  has_many :user_comics, dependent: :destroy
  has_many :owned_comics, through: :user_comics, source: :comic
  has_many :readings, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  attribute :admin, :boolean, default: false
end
