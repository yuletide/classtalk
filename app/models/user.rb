class User < ActiveRecord::Base
  #this represents, for now, a teacher with access to the system.
  #a user can create groups, and add students to those groups

  has_many :groups
  has_many :logged_messages, :as=>:sender, :dependent=>:nullify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :phone_number

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :display_name
  validates_phone_number :phone_number, :allow_nil=>true, :allow_blank=>true

  def name
    [first_name, last_name].compact.join(' ')
  end
end
