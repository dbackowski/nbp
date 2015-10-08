# Kursy NBP [![Build Status](https://travis-ci.org/dbackowski/nbp.svg)](https://travis-ci.org/dbackowski/nbp)

Testowy użytkownik tworzony podczas rake db:setup 

    email: foo@bar.com
    hasło: test.123

Polecenie rake db:setup importuje także archiwalne kursy z bieżacego roku (tak aby na start można było mieć sensowne raporty).

Pobieranie kolejnych aktualizacji kursów jest ustawione za pomocą sidekiq-cron na godzinę 8:30 rano (config/schedule.yml, tam jest 6:30 bo jest to według UTC)

Aby działały powiadomienia e-mailem należy w pliku .env ustawić następujące zmienne:

    SMTP_DEFAULT_FROM="adres e-mail nadawcy"
    SMTP_DOMAIN="twoja domena"
    SMTP_LOGIN="twój login"
    SMTP_PASSWORD="twoje hasło"
    SMTP_ADDRESS="adres serwera SMTP"

Interfejs sidekiq CRON jest dostępny pod adresem

    http://lvh.me:3000/sidekiq/cron