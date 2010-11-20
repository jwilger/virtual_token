class Token < ActiveRecord::Base
  def self.generate_slug(name)
    name.to_s.downcase.gsub(/\W+/, '-').gsub(/(^-|-$)/, '')
  end

  has_many :requests, :class_name => 'TokenRequest', :inverse_of => :token,
    :dependent => :destroy, :order => 'created_at ASC'

  before_validation :set_slug, :on => :create

  validates_presence_of :name, :slug
  validates_uniqueness_of :name

  def to_param
    slug
  end

  def claimed?
    requests.any?
  end

  def current_request
    requests.first
  end

  def claimed_by
    current_request ? current_request.user_name : nil
  end

  def claim_purpose
    current_request ? current_request.purpose : nil
  end

  def has_queue?
    false
  end

  def update_queue
    next_request = requests(true).first
    update_attribute(:claimed_at, next_request ? Time.now : nil)
  end

  private

  def set_slug
    self.slug = Token.generate_slug(name)
  end
end
