class User < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  has_many :books, -> { order 'created_at DESC' }
end
