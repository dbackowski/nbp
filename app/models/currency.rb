class Currency < ActiveRecord::Base
  belongs_to :exchange

  validates :name, presence: true
  validates :converter, presence: true
  validates :converter, numericality: { only_integer: true }, allow_blank: true
  validates :code, presence: true
  validates :buy_price, presence: true
  validates :buy_price, numericality: true, allow_blank: true
  validates :sell_price, presence: true
  validates :sell_price, numericality: true, allow_blank: true
  validates :exchange_id, presence: true
end
