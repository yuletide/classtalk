require 'spec_helper'
#factory girl doesn't play nice with user.

describe User do
  pending "is not registerable" do
    #this might be a controller test?
  end
    it "does require profile info after confirmation email is sent" do
    u=User.create(:email=>"email@yeaaah.com")
    u.should_not be_valid
  end
  it "can be confirmed" do
    u=User.create(:email=>"email@yeaaah.com")
    u.confirm!
    u.should be_confirmed
  end
  pending "disallows sign-in before confirmation" do
  end
  describe "their phone number, after confirmation" do
    before(:each) do
      @user=User.create!(:email=>"hi@hi.com",:first_name=>"testguy",:last_name=>"lastname",:display_name=>"j",:password=>"yeaaah",:password_confirmation=>"yeaaah")
      @user.confirm!
    end
      it "must be of the canonical format" do
      @user.phone_number="abc123"
      @user.should_not be_valid
      @user.phone_number="(123) 456-7890"
      @user.should be_valid
      @user.phone_number="1234567891"
      @user.should be_valid
    end
  end

  describe "their password" do
  end
end
