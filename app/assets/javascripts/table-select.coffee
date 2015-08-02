jQuery ->
  # Obsluga klikniec na listach (lewy przycisk myszy przechodzi do linka,
  # srodkowy lub lewy z ctr (cmd pod mac os x) przechodzi do linkach w nowym oknie).
  # W przypadku wykrycia zaznaczenia tekstu, nie robi nic.
  $(document).on 'mouseup', 'table.table.table-hover tr.clickable', (e) ->
    if window.getSelection().toString() && !(e.ctrlKey || e.metaKey)
      e.preventDefault()
    else if (e.ctrlKey || e.metaKey) && e.button == 0
      window.open($(this).data('url'))
    else if e.button == 1 || e.button == 4
      window.open($(this).data('url'))
    else if e.button == 0
      window.location = $(this).data('url')

  # Usuwa cale zaznaczenie tekstu w tabeli po kliknieciu lewym lub srodkowym przyciskiem myszy
  # (rozwiazanie problemu gdy mamy juz zaznaczony tekst i ponownie klikamy w wiersz)
  $(document).on 'mousedown', 'table.table.table-hover tr.clickable', (e) ->
    if e.button == 0 || e.button == 1 || e.button == 4
      window.getSelection().removeAllRanges()