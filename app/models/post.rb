class Post < ApplicationRecord
  belongs_to :user
  belongs_to :book

  attr_accessor :micropub_endpoint
  attr_accessor :access_token

  STATUS_NONE = 'none'
  STATUS_TO_READ = 'to-read'
  STATUS_READING = 'reading'
  STATUS_FINISHED = 'finished'

  STATUSES = [STATUS_NONE, STATUS_TO_READ, STATUS_READING, STATUS_FINISHED]
  STATUS_TEXT = [
    ['', STATUS_NONE],
    ['Want to read', STATUS_TO_READ],
    ['Reading', STATUS_READING],
    ['Finished', STATUS_FINISHED]
  ].freeze

  after_create :micropub_create

  def after_initialize
    status = STATUS_NONE
  end

  def micropub_create
    return if access_token.nil?
    return if STATUS_NONE == status

    u = URI.parse(micropub_endpoint)
    http = ::Net::HTTP.new(u.host, u.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
      'Authorization' => "Bearer #{access_token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    body = {type:['h-entry'], properties: {'summary': summary, 'read-status': status, 'read-of': read_of}}.to_json
    response = http.post(u.path, body, headers)
    Rails.logger.info "micropub_create: #{response.code} : #{response.body}"
    j = JSON.parse(response.body)
    if ['200','201','202'].include?(response.code)
      self.micropub_post_url = j['url']
      save
    else
      Rails.logger.info 'oops'
    end
  end

  def summary
    summary = ["#{status_text}: #{book.title} by #{book.author}, ISBN: #{book.isbn}"]
  end

  def read_of
    [
      {
        type: ['h-cite'],
        properties: {
          name: [book.title],
          author: [book.author],
          uid: ["isbn:#{book.isbn}"]
        }
      }
    ]
  end

  def status_text
    STATUS_TEXT.select {|i| i[1]==status}.first.first
  end
end
