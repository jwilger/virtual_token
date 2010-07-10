class Token < ActiveRecord::Base
  def self.generate_slug(name)
    name.to_s.downcase.gsub(/\W+/, '-').gsub(/(^-|-$)/, '')
  end

  def self.find(id)
    where(:slug => id).first || super
  end

  before_create :set_slug

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = Token.generate_slug(name)
  end
end
