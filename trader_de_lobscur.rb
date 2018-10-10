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


puts get_name_money("https://coinmarketcap.com/all/views/all/")
puts get_price_money("https://coinmarketcap.com/all/views/all/")