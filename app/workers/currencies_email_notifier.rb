class CurrenciesEmailNotifier
  include Sidekiq::Worker

  def perform(exchange_id)
    User.all.each do |user|
      CurrenciesNotifierMailer.currencies_update_email(user.email).deliver_now
    end
  end
end