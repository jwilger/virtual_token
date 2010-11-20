class Token < ActiveRecord::Base
  def self.generate_slug(name)
    name.to_s.downcase.gsub(/\W+/, '-').gsub(/(^-|-$)/, '')
  end

  has_many :requests, :class_name => 'TokenRequest'

  before_validation :set_slug, :on => :create

  validates_presence_of :name, :slug
  validates_uniqueness_of :name

  def to_param
    slug
  end

  def claimed?
    requests.any?
  end

  def has_queue?
    false
  end

  private

  def set_slug
    self.slug = Token.generate_slug(name)
  end
end
