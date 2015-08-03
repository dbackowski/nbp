require 'rails_helper'

RSpec.describe User, type: :model do
  def user(attributes = {})
    @user ||= FactoryGirl.build(:user, attributes)
  end

  it "has a valid factory" do
    expect(user).to be_valid
  end

  it "is invalid without a email" do
    expect(user(email: nil)).to have(1).error_on(:email)
  end

  it "is invalid without a password" do
    expect(user(password: nil)).to have(1).error_on(:password)
  end

  it "is invalid when password and password_confirmation are not equal" do
    expect(user(password_confirmation: 'test.test')).to have(1).error_on(:password_confirmation)
  end
end
