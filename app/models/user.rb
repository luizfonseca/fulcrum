class User < ActiveRecord::Base

  # FIXME - DRY up, repeated in Story model
  JSON_ATTRIBUTES = ["id", "name", "initials", "email"]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :name, :initials

  # Flag used to identify if the user was found or created from find_or_create
  attr_accessor :was_created

  has_and_belongs_to_many :projects, :uniq => true

  before_validation :set_random_password_if_blank

  validates :name, :presence => true
  validates :initials, :presence => true

  def to_s
    "#{name} (#{initials}) <#{email}>"
  end

  def set_random_password_if_blank
    if new_record? && self.password.blank? && self.password_confirmation.blank?
      self.password = self.password_confirmation = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--")[0,6]
    end
  end

  def as_json(options = {})
    super(:only => JSON_ATTRIBUTES)
  end
end
