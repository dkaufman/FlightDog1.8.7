#This file creates a scraper object, given date, origin, and destination
#The scrape method accesses the Jet Blue website, navigates the reservations search, and writes the resulting flight info to a file

#require 'nokogiri'
require 'mechanize'
#require 'open-uri'
#require 'Hpricot'


class JBCollect
	def initialize(date, fromCity, toCity)
		@date = date
		@fromCity = fromCity
		@toCity = toCity
	end


	def scrape
		#Open JetBlue reservations search page
		#In this case, the mobile page proved easier to navigate
		url = "http://mobile.jetblue.com/"
		agent = Mechanize.new
		homePage = agent.get(url)
		
		#Navigate to the one-way flight search, if not already on it
		searchPage = homePage.link_with(:text => "Book a flight").click
		oneWayLink = searchPage.link_with(:text => "Oneway")
		if oneWayLink.nil? == false
			searchPage = oneWayLink.click
		end
		
		#Fill out search form with flight information, store page with non-stop results
		searchForm = searchPage.form('searchForm')
		searchForm["origin"] = [@fromCity]
		searchForm["destination"] = [@toCity]
		searchForm["un_jtt_date1"] = [@date]
		results = agent.submit(searchPage.forms.first, searchPage.forms.first.buttons[3])
		nonstopResults = agent.submit(results.forms.first, results.forms.first.buttons.first)
		
		#Scrape price, departure time, arrival time, flight number, and seats remaining, store in arrays
		#All scrapes are based on CSS Selectors
		price_array = nonstopResults.search(".lmb_tb_b div div div b").map(&:text).map(&:strip)
		departs_array = nonstopResults.search(".lmb_tb_b div div div:nth-child(1)").map(&:text).map(&:strip)
		arrives_array = nonstopResults.search(".lmb_tb_b div:nth-child(2) div:nth-child(2)").map(&:text).map(&:strip)
		flights_array = nonstopResults.search("#outboundTable a").map(&:text).map(&:strip)
		seats_array = nonstopResults.search(".lmb_tb_b div:nth-child(4)").map(&:text).map(&:strip)
		
		#Clean departure array to remove initial text
		cleaned_departs_array = Array.new
		departs_array.each do |d|
			l = d.length
			cleaned_departs_array << d[10..l]
		end
		
		#Clean arrival array to remove initial text
		cleaned_arrives_array = Array.new
		arrives_array.each do |d|
			l = d.length
			cleaned_arrives_array << d[10..l]
		end
		
		#Clean seats remaining array to only number
		cleaned_seats_array = Array.new
		seats_array.each do |s|
			if s.include?("1")
				cleaned_seats_array << "1"
			elsif s.include?("2")
				cleaned_seats_array << "2"
			elsif s.include?("3")
				cleaned_seats_array << "3"
			elsif s.include?("4")
				cleaned_seats_array << "4"
			elsif s.include?("5")
				cleaned_seats_array << "5"
			else
				cleaned_seats_array << ""
			end
		end
		
		#Create output array of each flight record
		  output = Array.new
		  j = flights_array.length - 1
		  for i in (0..j)
			 output << Time.now.ctime + "," + @date + "," + @fromCity + "," + @toCity + "," + price_array[i] + "," + flights_array[i] + "," + cleaned_departs_array[i] + "," + cleaned_arrives_array[i] + "," + cleaned_seats_array[i] + "\n"
		  end
		#Appends data to file
		  File.open('C:\Sites\scraper\FlightPriceDataCollection\JBRawData17.txt', 'a') {|f| f.write(output) }
	end
end