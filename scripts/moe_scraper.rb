require 'nokogiri'
require 'open-uri'

def scraper

  doc = Nokogiri::HTML(open("http://www.education.govt.nz/our-work/consultations/open-consultations/", 
                            "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3", 
                            "Accept-Encoding" => "gzip, deflate", 
                            "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8", 
                            "Cache-Control" => "max-age=0",
                            "Connection" => "keep-alive",
                            "Cookie" => "visid_incap_169238=Vx4Vm1JyQrWq+Tw4qAHNmOb7tV0AAAAAQUIPAAAAAAAHpFHPg3b0KnJ2NpdgZQLu; _ga=GA1.3.1361343945.1572207616; incap_ses_364_169238=OS1YHcUxf1iIM+we+zANBUiRuF0AAAAAxjUpH0L0nTpianvEc15iiA==; _gid=GA1.3.1688047299.1572376909",
                            "Host" => "www.education.govt.nz",
                            "Referer" => "http://www.education.govt.nz/our-work/consultations/", 
                            "Upgrade-Insecure-Requests" => "1", 
                            "User-Agent" => "mozilla/5.0 (x11; linux x86_64) applewebkit/537.36 (khtml, like gecko) chrome/77.0.3865.90 safari/537.36",
                            ))
	
	consultations = doc.css("main#main-content p").css("p:not(.updated-feedback)")
byebug	
	retries = 0 

	begin 
	consultations.each do |c|

    sleep(rand(10.1..15))
		
		department = "MoE"
		title = c.css("a").children.text
		url = "http://www.education.govt.nz" + c.css("a")[0]["href"]
		
		consult = Nokogiri::HTML(open(url, "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3", "Accept-Encoding" => "gzip, deflate", "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8", "Connection" => "keep-alive",
                            "user-agent" => "mozilla/5.0 (x11; linux x86_64) applewebkit/537.36 (khtml, like gecko) chrome/77.0.3865.90 safari/537.36",
                            "referer" => "http://www.education.govt.nz/our-work/consultations/open-consultations/", "upgrade-insecure-requests" => "1", "host" => "www.education.govt.nz"))
		
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
