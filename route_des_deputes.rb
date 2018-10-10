# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'


# récupère le prénom nom et email d'un député
def get_the_name_and_email_of_a_depute(url)
  page = Nokogiri::HTML(open(url))
  name = page.css('h1').text
  name=name.split
  first_name=name[1]
  last_name=name[2]
  link = page.xpath('/html/body/div[3]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li/a').map { |link| link['href'] }
  # les pages étants identiques, on a pris le xpath précis de l'adresse mail d'un député
  email=link.to_s.gsub!(/mailto:/, '').gsub!(/["\[\]]/,'')
  {:first_name =>first_name,:last_name=>last_name,:email=>email}
end

# récuperer l'url des deputee
def get_all_the_urls_of_all_deputee(url)
  url_general="http://www2.assemblee-nationale.fr"
  page = Nokogiri::HTML(open(url))
  link=page.xpath('//div[@class="clearfix col-container"]')
  link=link.css('a').map { |link| url_general+link['href'] }
  # on récupère les urls contenues dans la classe lientxt et on les mets dans le bon format
  puts link.class
end


# récupère les emails de toutes les députes par ordre alphabétique
def get_all_names_and_email_of_deputee(url)
  url_deputee = get_the_name_and_email_of_a_depute(url)
  puts url_deputee.class
  all_deputee = Array.new
  url_deputee.each { |x| all_deputee << get_the_name_and_email_of_a_depute(x) }
  # on récupère les noms et mails de chaque députés
  all_deputee
end

#puts get_the_name_and_email_of_a_depute("http://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA720310")
puts get_all_the_urls_of_all_deputee("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique")
puts get_all_names_and_email_of_deputee("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique")