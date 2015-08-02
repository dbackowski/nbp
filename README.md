# Kursy NBP

Testowy użytkownik tworzony przy podczas rake db:setup 

    email: foo@bar.com
    hasło: test.123

powyższe polecenie importuje także archiwalne kursy z bieżacego roku (tak aby na start można było mieć sensowne raporty).

Pobieranie kolejnych aktualizacji kursów jest ustawione za pomocą sidekiq-cron na godzinę 8:30 rano (config/schedule.yml, tam jest 6:30 bo to według UTC)

Aby działały powiadomienia e-mailem należy w pliku .env ustawić następujące zmienne:

    SMTP_DEFAULT_FROM="adres e-mail nadawcy"
    SMTP_DOMAIN="twoja domena"
    SMTP_LOGIN="twój login"
    SMTP_PASSWORD="twoje hasło"
    SMTP_ADDRESS="adres serwera SMTP"

Interfejs sidekiq CRON jest dostępny pod adresem

    http://lvh.me:3000/sidekiq/cron