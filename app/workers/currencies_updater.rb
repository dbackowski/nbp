class CurrenciesUpdater
  include Sidekiq::Worker

  def perform
    nbp_parser = NbpParser.new
    data = nbp_parser.get_data
    return if Exchange.where(quotation_date: data[:exchange][:quotation_date]).first.present?

    ActiveRecord::Base.transaction do
      exchange = Exchange.create!(data[:exchange])

      data[:currencies].each do |currency|
        Currency.create!(currency.merge(exchange_id: exchange.id))
      end

      CurrenciesEmailNotifier.perform_async(exchange.id)
    end
  end
end
