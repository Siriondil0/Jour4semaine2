# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'


def get_name_money(url)
  page = Nokogiri::HTML(open(url))
  page.xpath('//a[@class="currency-name-container link-secondary"]').map { |link| link.text }
  # on récupère les urls contenues dans la classe lientxt

end

def get_price_money(url)
  page = Nokogiri::HTML(open(url))
  page.css('.price').map { |link| link.text }
  # on récupère les urls contenues dans la classe lientxt
end

def create_hash_name_price (name,price)
  name.zip(price).map{|name, price| {Nom: name, Prix: price}}
end

def perform
  address="https://coinmarketcap.com/all/views/all/"
  puts create_hash_name_price(get_name_money(address),get_price_money(address))
end

def every_minutes_excecute 
  while true do
    t = Time.now
    puts "Debut de la mise à jour"
    perform
    puts "Fin de la mise à jour"
    sleep(t + 3600 - Time.now)
  end
end

puts "La fonction s'execute une fois toutes les heures. Pour arrêter l'exécution, faite ctrl +c "
every_minutes_excecute