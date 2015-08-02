# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Create default user"
User.create!(email: 'foo@bar.com', password: 'test.123', password_confirmation: 'test.123')

require 'open-uri'

open("http://www.nbp.pl/kursy/xml/dir.txt", "r:utf-8") do |f|
  files = f.readlines.map { |line| line.strip! }.select { |line| line =~ /^c[0-9]{3}z[0-9]{6}$/ }

  files.each do |file_name|
    nbp_parser = NbpParser.new(file_name: "#{file_name}.xml")
    data = nbp_parser.get_data

    puts "Importing archived exchange rates for: #{data[:exchange][:quotation_date]}"
    ActiveRecord::Base.transaction do
      exchange = Exchange.create!(data[:exchange])

      data[:currencies].each do |currency|
        Currency.create!(currency.merge(exchange_id: exchange.id))
      end
    end
  end
end
