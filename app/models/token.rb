class Token < ActiveRecord::Base
  def self.generate_slug(name)
    name.to_s.downcase.gsub(/\W+/, '-').gsub(/(^-|-$)/, '')
  end

  has_many :requests, :class_name => 'TokenRequest', :inverse_of => :token,
    :dependent => :destroy, :order => 'position ASC'

  before_validation :set_slug, :on => :create

  validates_presence_of :name, :slug
  validates_uniqueness_of :name

  def self.other_tokens(t)
    Token.order('updated_at desc').where( 'tokens.id != ?', t).limit(10)
  end

  def to_param
    slug
  end

  def claimed?
    requests.any?
  end

  def current_request(reload = false)
    requests(reload).first
  end

  def claimed_by
    current_request ? current_request.user : nil
  end

  def claimed_at
    current_request ? current_request.claim_granted_at : nil
  end

  def claim_purpose
    current_request ? current_request.purpose : nil
  end

  def queue
    requests.where(:claim_granted_at => nil)
  end

  def has_queue?
    queue.any?
  end

  def update_queue
    if _current_request = current_request(true)
      _current_request.grant_claim
    end
  end

  private

  def set_slug
    self.slug = Token.generate_slug(name)
  end
end
