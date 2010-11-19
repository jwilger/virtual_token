class Token < ActiveRecord::Base
  def self.generate_slug(name)
    name.to_s.downcase.gsub(/\W+/, '-').gsub(/(^-|-$)/, '')
  end

  def self.find(id)
    where(:slug => id).first || super
  end

  before_validation :set_slug, :on => :create

  validates_presence_of :name, :slug
  validates_uniqueness_of :name

  def to_param
    slug
  end

  def claimed?
    false
  end

  private

  def set_slug
    self.slug = Token.generate_slug(name)
  end
end
