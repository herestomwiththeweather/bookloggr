class Book < ApplicationRecord
  belongs_to :user

  has_many :logs

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true, uniqueness: true
end
