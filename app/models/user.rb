class User < ActiveRecord::Base
  #this represents, for now, a teacher with access to the system.
  #a user can create groups, and add students to those groups

  has_many :groups
  has_many :logged_messages, :as=>:sender, :dependent=>:nullify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :phone_number, :show_group_number_popup, :time_zone

  validates_presence_of :first_name
  validates_format_of :first_name, :without => /\bFirst\b/,
    :message => "name can't be blank"
  validates_presence_of :last_name
  validates_format_of :last_name, :without => /\bLast\b/,
    :message => "name can't be blank"
  validates_presence_of :display_name
  validates_format_of :display_name, :without => /\Ae.g. Mr. S\z/,
    :message => "can't be blank"
  validates_phone_number :phone_number, :allow_nil=>true, :allow_blank=>true

  def name
    [first_name, last_name].compact.join(' ')
  end
end
