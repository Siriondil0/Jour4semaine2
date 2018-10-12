# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'

# récupère le nom et prénom d'un député à partir de sa page
def get_name_of_a_deputee(page)
  name = page.css('h1').text
  # on enlève les accents pour éviter les charactères spéciaux dans les hash et on split name
  name = name.gsub(/É/,'E').gsub(/[ëêéè]/, 'e').gsub(/ç/, 'c').gsub(/À/, 'A').gsub(/ï/, 'i').gsub(/ö/, 'o').split
  first_name = name[1]
  # les noms de familles peuvent être séparés par des espaces, on les récupères avec le test ci après
  if name[3]
    last_name = name[2] + " " + name[3..-1].join(" ")
  else
    last_name = name[2]
  end 
  [first_name, last_name]
end

# récupère le prénom nom et email d'un député
def get_the_name_and_email_of_a_depute(url)
  page = Nokogiri::HTML(open(url))
  name = get_name_of_a_deputee(page)
  # Il existe trois sortes de pages de députés: ceux avec un email et une collaboratrice
  # , ceux avec un email et pas de collaboratrice et ceux sans email. On teste chacune de ces possibilités
  link = page.xpath('/html/body/div[3]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li/a').map { |x| x['href'] }
  # Si la case est vide, ou que le lien est un site internet, le député n'a pas de suppléant
  # On regarde alors sur le lien suivant
  if (link[0].class == NilClass) || (link[0] =~ /https/)
    link = page.xpath('/html/body/div[3]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[3]/ul/li/a').map { |x| x['href'] }
  end
  # Si le lien est vide, il n'y a pas d'email
  if link[0].class == NilClass
    email = "Pas d'email renseigne"
  else
    email = link[0].gsub(/mailto:/, '') 
  end
  info = { :first_name => name[0], :last_name => name[1], :email => email }
  puts info
  info
end

# récuperer l'url de chaque deputee dans un tableau
def get_all_the_urls_of_all_deputee(url)
  url_general = "http://www2.assemblee-nationale.fr"
  page = Nokogiri::HTML(open(url))
  # on récupère le contenu de la classe clearfix col-container (dont une sous-partie contient les liens)
  link = page.xpath('//div[@class="clearfix col-container"]')
  # on récupère les urls contenues dans les liens du tableau  et on les mets dans le bon format
  link = link.css('a').map { |x| url_general + x['href'] }
end

# récupère les emails de toutes les députes en utilisant la page de l'assemblée par ordre alphabétique
def get_all_names_and_email_of_deputee(url)
  url_deputee = get_all_the_urls_of_all_deputee(url)
  all_deputee = Array.new
  url_deputee.each { |x| all_deputee << get_the_name_and_email_of_a_depute(x) }
  # on récupère les noms et mails de chaque députés
  all_deputee
end

puts get_the_name_and_email_of_a_depute("http://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA340357")
puts "L'execution peut prendre quelques minutes, merci de votre patience "
tab = get_all_names_and_email_of_deputee("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique")
puts tab[5]