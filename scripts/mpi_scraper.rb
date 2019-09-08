require 'nokogiri'
require 'open-uri'

def scraper

	doc = Nokogiri::HTML(open("https://www.mpi.govt.nz/news-and-resources/consultations/?opened=1"))
	
	consultations = doc.css("article.media-release.consultation-category.consultationArticle")

	consultations.each do |c|
		
		department = "MPI"
		title = c.css("h2.consultationArticle__title a").children.text
		closing_date = c.css("dd.date").children.text
		about = c.css("div.article-abstract p").children.text
		url = c.css("h2.consultationArticle__title a")[0]["href"]
		data = {}
		data = { 
			:title => title,
			:department => department,
			:closing_date => closing_date,
			:about => about,

			:url => url
		}

		Consultation.where(department: department, title: title).first_or_create!(data)


	end	
end

scraper
