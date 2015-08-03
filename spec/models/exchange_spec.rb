require 'rails_helper'

RSpec.describe Exchange, type: :model do
  def exchange(attributes = {})
    @exchange ||= FactoryGirl.build(:exchange, attributes)
  end

  it "has a valid factory" do
    expect(exchange).to be_valid
  end

  it "is invalid without a name" do
    expect(exchange(name: nil)).to have(1).error_on(:name)
  end

  it "is invalid without a quotation_date" do
    expect(exchange(quotation_date: nil)).to have(1).error_on(:quotation_date)
  end

  it "is invalid without a publication_date" do
    expect(exchange(publication_date: nil)).to have(1).error_on(:publication_date)
  end
end
