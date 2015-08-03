FactoryGirl.define do
  factory :currency do
    name "dolar amerykański"
    converter 1
    code "USD"
    buy_price 3.7037
    sell_price 3.7785
    association :exchange, :factory => :exchange
  end
end
