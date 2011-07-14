#This file gets the necessary date information for collecting the data
#It then passes that information to the AirTran scraper, along with the airport information for each route
#Since AirTran allows searching in 5 day windows, the script submits requests on 5 day intervals

require 'ATCollect.rb'


#Get current Date
currentYear = Time.now.year
currentMonth = Time.now.month
currentDay = Time.now.day
leapYear = currentYear%4

#Calculate how many days are in the current month
if [4,6,9,11].include? currentMonth
	daysInMonth = 30
elsif currentMonth == 2 && leapYear == 0
	daysInMonth = 29
elsif currentMonth == 2
	daysInmonth = 28
else
	daysInMonth = 31
end

#Collect flight data for flights between 6 and 25 days away
#Each submission records 5 dates, need to only submit 8, 13, 18, 23
puts "Started data collection " + Time.now.to_s
for i in [8,13,18,23]
	flightMonth = currentMonth
	flightDay = currentDay + i
	flightYear = currentYear
	formattedFlightMonth = ""
	if flightDay > daysInMonth
		flightDay = flightDay - daysInMonth
		flightMonth += 1
	end
	if flightMonth == 13
		flightMonth = 1
		flightYear += 1
	end
	if flightMonth < 10
		flightMonth = "0" + flightMonth.to_s
	end
	formattedFlightMonth = flightYear.to_s + "-" + flightMonth.to_s
	
	#Creates scraper for each route and calls scrape method
	#Each route (one-way) requires its own line
	puts "Scraping BOS for " + flightDay.to_s + " " + flightMonth.to_s
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BOS", "BWI").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BOS", "MKE").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BOS", "ATL").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BOS", "MCO").scrape
	puts "Scraping BWI for " + flightDay.to_s + " " + flightMonth.to_s
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BWI", "BOS").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BWI", "MKE").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BWI", "ATL").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "BWI", "MCO").scrape
	puts "Scraping MKE for " + flightDay.to_s + " " + flightMonth.to_s
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MKE", "BOS").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MKE", "BWI").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MKE", "ATL").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MKE", "MCO").scrape
	puts "Scraping ATL for " + flightDay.to_s + " " + flightMonth.to_s
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "ATL", "BOS").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "ATL", "BWI").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "ATL", "MKE").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "ATL", "MCO").scrape
	puts "Scraping MCO for " + flightDay.to_s + " " + flightMonth.to_s
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MCO", "BOS").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MCO", "BWI").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MCO", "ATL").scrape
	ATCollect.new(flightDay.to_s, flightMonth.to_s, "MCO", "MKE").scrape
end
puts "Finished Data Collection at " + Time.now.to_s
