require 'rails_helper'

RSpec.describe Currency, type: :model do
  def currency(attributes = {})
    @currency ||= FactoryGirl.build(:currency, attributes)
  end

  it "has a valid factory" do
    expect(currency).to be_valid
  end

  it "is invalid without a name" do
    expect(currency(name: nil)).to have(1).error_on(:name)
  end

  it "is invalid without a converter" do
    expect(currency(converter: nil)).to have(1).error_on(:converter)
  end

  it "is invalid when a converter is not integer" do
    expect(currency(converter: 'asd')).to have(1).error_on(:converter)
  end

  it "is invalid without a buy_price" do
    expect(currency(buy_price: nil)).to have(1).error_on(:buy_price)
  end

  it "is invalid when a buy_price is not numeric" do
    expect(currency(buy_price: '123asds')).to have(1).error_on(:buy_price)
  end

  it "is invalid without a sell_price" do
    expect(currency(sell_price: nil)).to have(1).error_on(:sell_price)
  end

  it "is invalid when a sell_price is not numeric" do
    expect(currency(sell_price: '123asds')).to have(1).error_on(:sell_price)
  end

  it "is invalid without a exchange_id" do
    expect(currency(exchange_id: nil)).to have(1).error_on(:exchange_id)
  end
end
