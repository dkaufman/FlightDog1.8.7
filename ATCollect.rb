#This file creates a scraper object, given date, origin, and destination
#The scrape method accesses the AirTran website, navigates the reservations search, and writes the resulting flight info to a file

require 'rubygems'
#require 'nokogiri'
require 'mechanize'
#require 'open-uri'
#require 'Hpricot'


class ATCollect
	def initialize(day, month, fromCity, toCity)
		@day = day
		@month = month
		@fromCity = fromCity
		@toCity = toCity
	end
	
	def scrape
		#Open AirTran reservations search page
		url = "http://www.airtran.com/Home.aspx"
		agent = Mechanize.new
		page = agent.get(url)
		
		#Fill out SkySales form, Submit
		#Force one way, dates 2 days on either side from date
		skySales = page.form_with(:name => 'SkySales')
		skySales.radiobutton_with(:value => 'OneWay').check
		skySales["ATAvailabilitySearchInputSearchView$DropDownListMarketOrigin1"] = [@fromCity]
		skySales["ATAvailabilitySearchInputSearchView$DropDownListMarketDestination1"] = [@toCity]
		skySales["ATAvailabilitySearchInputSearchView$DropDownListMarketDay1"] = [@day]
		skySales["ATAvailabilitySearchInputSearchView$DropDownListMarketMonth1"] = [@month]
		skySales["ATAvailabilitySearchInputSearchView$DropDownListMarketDateRange1"] = ["2|2"]
		results = agent.submit(skySales)

		#Click on link for printable results
		printable_results = results.links.find { |l| l.text == 'Printer-friendly version' }.click

		#Scrape prices off printable results
		#All scrapes are based on CSS Selectors
		price_array = printable_results.search("td:nth-child(5)").map(&:text).map(&:strip)

		#Scrape seats remaining, clean seats remaining to just the number
		seats_array=printable_results.search("td:nth-child(6)").map(&:text).map(&:strip)
		final_seats_array = Array.new
		j = seats_array.length-1
		for i in (0..j)
			final_seats_array[i] = seats_array[i].first
		end
		cleaned_seats_array = Array.new
		final_seats_array.each do |s|
			if s.to_s.include? "$"
				cleaned_seats_array << ""
			elsif s.to_s.include? "1"
				cleaned_seats_array << "1"
			elsif s.to_s.include? "2"
				cleaned_seats_array << "2"
			elsif s.to_s.include? "3"
				cleaned_seats_array << "3"
			elsif s.to_s.include? "4"
				cleaned_seats_array << "4"
			elsif s.to_s.include? "5"
				cleaned_seats_array << "5"
			else
				cleaned_seats_array << ""
			end
		  end

		  #Scrape non-stop boolean, departure time, arrival time, flight duration
		  nonstop_array = printable_results.search("td:nth-child(4)").map(&:text).map(&:strip)
		  j = nonstop_array.length - 1
		  for i in (0..j)
		  	a = nonstop_array[i]
			if a.include?("non")
				nonstop_array[i] = "nonstop"
			else
				nonstop_array[i] = "multi-stop"
			end
		  end
		  departs_array = printable_results.search("#flightmatrix_row :nth-child(2) .sortkey").map(&:text).map(&:strip)
		  j = departs_array.length - 1
		  #AirTran appears to have a bug where it sometimes adds 12 hours to an afternoon departure
		  #This block corrects that error
		  for i in (0..j)
			departs_array[i] = departs_array[i].to_i
		  	if departs_array[i] >= 2400
				departs_array[i] -= 1200
			end
		  end
		 
		  arrives_array = printable_results.search(":nth-child(3) .sortkey").map(&:text).map(&:strip)
		  duration_array = printable_results.search("td:nth-child(4) .sortkey").map(&:text).map(&:strip)

		#Scrape flight number and flight dates simultaneously
		@flight_array = printable_results.search(".selectsub span , #flightmatrix_row td:nth-child(1)").map(&:text).map(&:strip)
		
		#The flight number scrape also picks up seats remaining, so all of those objects are cleaned from the array
		@flight_array.delete_if {|x| x == "" || x.include?("seat") }
		
		#Split up flight number and flight date arrays 
		@all_date_array = @flight_array[0,5]
		@flight_array.slice!(0,5)
		j = @flight_array.length-1
		
		#Clean flight number array
		for i in (0..j)
			a = @flight_array[i]
			@flight_array[i] = a[0,3]
		end
		
		#Create new array that matches date of each flight
		#Switches to next date if departure time rolls over to next day
		@date_array = Array.new
		j = departs_array.length-1
		day_we_are_on = 0
		for k in (0..j)
			if k == 0
				@date_array[k] = @all_date_array[k]
			elsif departs_array[k] < departs_array[k-1]
				day_we_are_on += 1
				@date_array[k] = @all_date_array[day_we_are_on]
			else
				@date_array[k] = @all_date_array[day_we_are_on]
			end
			@date_array[k].slice!("Flights on ")
			@date_array[k] = @date_array[k].gsub(/\,/,"")
		end
		
		#Create output array of each flight record
		  output = Array.new
		  for i in (0..j)
			 output << Time.now.ctime + "," + @date_array[i] + "," + @fromCity + "," + @toCity + "," + price_array[i] + "," + @flight_array[i] + "," + nonstop_array[i].to_s + "," + departs_array[i].to_s + "," + arrives_array[i] + "," + duration_array[i] + "," + cleaned_seats_array[i] + "\n"
		  end
		  
		#Appends data to file
		  File.open('C:\Sites\scraper\FlightPriceDataCollection\RawDataM.txt', 'a') {|f| f.write(output) }		  
	end
end