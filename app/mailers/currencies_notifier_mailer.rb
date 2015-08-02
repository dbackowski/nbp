class CurrenciesNotifierMailer < ApplicationMailer
  default from: ENV['SMTP_DEFAULT_FROM']

  def currencies_update_email(mail_to)
    mail(to: mail_to, subject: 'Aktualizacja kursów')
  end
end