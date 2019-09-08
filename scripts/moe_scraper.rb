require 'nokogiri'
require 'open-uri'

def scraper

	doc = Nokogiri::HTML(open("http://www.education.govt.nz/our-work/consultations/open-consultations"))
	
	consultations = doc.css("main#main-content p").css("p:not(.updated-feedback)")
	
	retries = 0 

	begin 
	consultations.each do |c|
		
		department = "MoE"
		title = c.css("a").children.text
		url = "http://www.education.govt.nz" + c.css("a")[0]["href"]
		
		consult = Nokogiri::HTML(open(url))
		
		closing_date = consult.css("strong").text
		
		about = consult.css("p.intro").text

		data = {}
		data = {
			:title => title.strip,			
			:department => department,
			:closing_date => closing_date,
			:about => about.strip,

			:url => url
		}
		Consultation.where(department: department, title: title).first_or_create!(data)

	end
	rescue => e
		retries += 1
		if retries < 3
			retry
		else
			puts "Couldn't connect"
		end
	end
end

scraper
