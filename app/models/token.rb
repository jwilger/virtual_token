class Token < ActiveRecord::Base
  def self.generate_slug(name)
    name.to_s.downcase.gsub(/\W+/, '-').gsub(/(^-|-$)/, '')
  end

  def self.generate_name(slug)
    slug.to_s.gsub('-', ' ').titleize
  end

  def self.find(id)
    where(:slug => id).first || super
  end

  before_validation :set_slug_if_blank
  before_validation :set_name_if_blank

  validates_presence_of :name, :slug

  def to_param
    slug
  end

  private

  def set_slug_if_blank
    if slug.blank?
      self.slug = Token.generate_slug(name)
    end
  end

  def set_name_if_blank
    if name.blank?
      self.name = Token.generate_name(slug)
    end
  end
end
