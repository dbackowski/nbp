class Exchange < ActiveRecord::Base
  has_many :currencies, -> { order(:name) }

  validates :name, presence: true
  validates :quotation_date, presence: true
  validates :publication_date, presence: true
end
