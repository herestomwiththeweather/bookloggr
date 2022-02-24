class Book < ApplicationRecord
  belongs_to :user

  has_many :logs

  validates :title, presence: true
  validates :author, presence: true
end
