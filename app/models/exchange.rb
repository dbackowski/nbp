class Exchange < ActiveRecord::Base
  has_many :currencies, -> { order(:name) }
end
