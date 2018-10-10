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

address="https://coinmarketcap.com/all/views/all/"
puts create_hash_name_price(get_name_money(address),get_price_money(address))
