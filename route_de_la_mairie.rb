# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'

# récupérer l'email d'une ville
def get_the_email_of_a_townhal_from_its_webpage(url)
  page = Nokogiri::HTML(open(url))
  link = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]')
  # les pages étants identiques, on a pris le xpath précis de l'adresse mail d'une ville
  link.to_s.gsub!(/<\/td>/, '').gsub!(/<td>/, '')
end

# récuperer l'url des villes du val d'oise
def get_all_the_urls_of_val_doise_townhalls(url)
  page = Nokogiri::HTML(open(url))
  page.css('.lientxt').map { |link| link['href'] }
  # on récupère les urls contenues dans la classe lientxt
end

# transforme les string de array_of_url du format ./95/maville.html à maville
def recup_name_of_city(array_of_url)
  arr = Marshal.load(Marshal.dump(array_of_url))
  arr.each { |x| x.gsub!(/.\/95\//, '').gsub!(/.html/, '') }
end

# récupère les emails de toutes les villes du val d'oise
def get_all_email_and_ulrs_of_val_doise(url)
  general_url = "http://annuaire-des-mairies.com/95"
  # on récupère les urls dans url val d'oise
  urls_val_doise = get_all_the_urls_of_val_doise_townhalls(url)
  town = recup_name_of_city(urls_val_doise)
  email_town = []
  urls_val_doise.each { |x| x.gsub!(/.\/95/, general_url) }
  urls_val_doise.each { |x| email_town << get_the_email_of_a_townhal_from_its_webpage(x) }
  # on récupère les emails de chaque villes
  town.zip(email_town).map{|town, town_email| {name: town, email: town_email}}
  # on met les emails dans un hash {name =>ville, email=>email de la ville}
end

#perform les 3 autres fonctions
def perform
  puts get_the_email_of_a_townhal_from_its_webpage("http://annuaire-des-mairies.com/95/vaureal.html")
  print get_all_the_urls_of_val_doise_townhalls("http://annuaire-des-mairies.com/val-d-oise.html")
  puts
  puts "La dernière fonction met environ une minute à s'executer, désolé de l'attente"
  puts get_all_email_and_ulrs_of_val_doise("http://annuaire-des-mairies.com/val-d-oise.html")
end

perform