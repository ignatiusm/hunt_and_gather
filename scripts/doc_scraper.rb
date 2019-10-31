require 'nokogiri'
require 'open-uri'

# doc page includes some closed consultations. Need to handle these
def scraper

  base_url = "https://www.doc.govt.nz"

	doc = Nokogiri::HTML(open("https://www.doc.govt.nz/get-involved/have-your-say/open-for-your-comment/"))
  consultations = doc.css("div.list-item")

	consultations.each do |c|
    link = c.css("h3 a")[0]["href"]

    sleep(10)

    consult = Nokogiri::HTML(open(base_url + link))
    
    department = "DOC"
		title = consult.css("h1.long").children.text
    byebug
    closing_date = consult.css("p /strong").last.children.text
    about = consult.css("span.introduction-text").children.text.strip
		url = base_url+link
    data = {}
		data = { 
			:title => title,
			:department => department,
			:closing_date => closing_date,
			:about => about,

			:url => url
		}

		Consultation.where(department: department, title: title).first_or_create!(data)
    puts "consultation created \n"


	end	
end

scraper
