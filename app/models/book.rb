class Book < ApplicationRecord
  belongs_to :user

  has_many :logs, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_one_attached :main_ebook

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true

  before_validation :normalize_isbn, :on => :create
  before_destroy :delete_attachment

  def normalize_isbn
    self.isbn = StdNum::ISBN.normalize(isbn)
  end

  def delete_attachment
    if main_ebook.attached?
      main_ebook.purge
    end
  end

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
