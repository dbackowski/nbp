require 'nokogiri'
require 'open-uri'

class NbpParser
  def initialize(file_name: 'lastC.xml')
    @data = { exchange: {}, currencies: [] }
    @file_name = file_name
  end

  def get_data
    parse
    @data
  end

  private

  def parse
    doc = Nokogiri::XML(open("http://www.nbp.pl/kursy/xml/#{@file_name}"))

    @data[:exchange][:name] = doc.xpath('//tabela_kursow/numer_tabeli').text
    @data[:exchange][:quotation_date] = doc.xpath('//tabela_kursow/data_notowania').text
    @data[:exchange][:publication_date] = doc.xpath('//tabela_kursow/data_publikacji').text

    doc.xpath('//tabela_kursow/pozycja').each do |node|
      @data[:currencies] << parse_currency(node)
    end
  end

  def parse_currency(node)
    { name: node.xpath('nazwa_waluty').text,
      converter: node.xpath('przelicznik').text.to_i,
      code: node.xpath('kod_waluty').text,
      buy_price: string_to_float(node.xpath('kurs_kupna').text),
      sell_price: string_to_float(node.xpath('kurs_sprzedazy').text) }
  end

  def string_to_float(text)
    text.gsub!(',', '.').to_f
  end
end
