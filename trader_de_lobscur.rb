# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'

# Récupère un tableau contenant le nom des monnaies
def get_name_money(url)
  page = Nokogiri::HTML(open(url))
  # on récupère le texte contenu dans la classe currency-name-container link-secondary
  page.xpath('//a[@class="currency-name-container link-secondary"]').map { |link| link.text }
end

# Récupère un tableau contenant le prix des monnaies
def get_price_money(url)
  page = Nokogiri::HTML(open(url))
  # on récupère le texte contenu dans la classe price
  page.css('.price').map { |link| link.text }
  
end

#cree un hash avec les tableaux name et price
def create_hash_name_price (name,price)
  name.zip(price).map{|name, price| {Nom: name, Prix: price}}
end

# perform les fonctions
def perform
  address="https://coinmarketcap.com/all/views/all/"
  puts create_hash_name_price(get_name_money(address),get_price_money(address))
end

# exécute la fonction une fois par heure
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