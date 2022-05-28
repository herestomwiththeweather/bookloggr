require 'uri'
require 'net/https'

class Log < ApplicationRecord
  belongs_to :user
  belongs_to :book

  default_scope { order(page: :desc) }


end
