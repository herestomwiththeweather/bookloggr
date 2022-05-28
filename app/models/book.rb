class Book < ApplicationRecord
  belongs_to :user

  has_many :logs
  has_many :posts
  has_one_attached :main_ebook

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true, uniqueness: true

  def search_pages(text)
    pages = []
    self.main_ebook_blob.open do |tempfile|
      reader = PDF::Reader.new(tempfile)
      reader.pages.each do |page|
        if page.text.gsub(/\t/,'').match?(/#{text}/i)
          pages << page.number
        end
      end
    end
    pages
  end
end
