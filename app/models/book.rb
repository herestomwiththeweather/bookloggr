class Book < ApplicationRecord
  belongs_to :user

  has_many :logs
  has_one_attached :main_ebook

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true, uniqueness: true
end
