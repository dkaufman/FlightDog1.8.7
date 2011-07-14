#This file gets the necessary date information for collecting the data
#It then passes that information to the JetBlue scraper, along with the airport information for each route

require 'JBCollect.rb'

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
puts "Started data collection " + Time.now.to_s
for i in (6..25)
	flightMonth = currentMonth
	flightDay = currentDay + i
	flightYear = currentYear
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
	if flightDay < 10
		flightDay = "0" + flightDay.to_s
	end
	formattedFlightDate = flightYear.to_s + "-" + flightMonth.to_s + "-" + flightDay.to_s

	#Creates scraper for each route and calls scrape method
	#Each route (one-way) requires its own line
	puts "Scraping BOS for " + formattedFlightDate
	JBCollect.new(formattedFlightDate, "BOS", "BWI").scrape
	JBCollect.new(formattedFlightDate, "BOS", "LGB").scrape
	JBCollect.new(formattedFlightDate, "BOS", "MCO").scrape
	JBCollect.new(formattedFlightDate, "BOS", "FLL").scrape
	JBCollect.new(formattedFlightDate, "BOS", "NYC").scrape
	puts "Scraping BWI for " + formattedFlightDate
	JBCollect.new(formattedFlightDate, "BWI", "BOS").scrape
	JBCollect.new(formattedFlightDate, "BWI", "LGB").scrape
	JBCollect.new(formattedFlightDate, "BWI", "MCO").scrape
	JBCollect.new(formattedFlightDate, "BWI", "FLL").scrape
	JBCollect.new(formattedFlightDate, "BWI", "NYC").scrape
	puts "Scraping LGB for " + formattedFlightDate
	JBCollect.new(formattedFlightDate, "LGB", "BWI").scrape
	JBCollect.new(formattedFlightDate, "LGB", "BOS").scrape
	JBCollect.new(formattedFlightDate, "LGB", "MCO").scrape
	JBCollect.new(formattedFlightDate, "LGB", "FLL").scrape
	JBCollect.new(formattedFlightDate, "LGB", "NYC").scrape
	puts "Scraping MCO for " + formattedFlightDate
	JBCollect.new(formattedFlightDate, "MCO", "BWI").scrape
	JBCollect.new(formattedFlightDate, "MCO", "LGB").scrape
	JBCollect.new(formattedFlightDate, "MCO", "BOS").scrape
	JBCollect.new(formattedFlightDate, "MCO", "FLL").scrape
	JBCollect.new(formattedFlightDate, "MCO", "NYC").scrape
	puts "Scraping FLL for " + formattedFlightDate
	JBCollect.new(formattedFlightDate, "FLL", "BWI").scrape
	JBCollect.new(formattedFlightDate, "FLL", "LGB").scrape
	JBCollect.new(formattedFlightDate, "FLL", "MCO").scrape
	JBCollect.new(formattedFlightDate, "FLL", "BOS").scrape
	JBCollect.new(formattedFlightDate, "FLL", "NYC").scrape
		puts "Scraping NYC for " + formattedFlightDate
	JBCollect.new(formattedFlightDate, "NYC", "BWI").scrape
	JBCollect.new(formattedFlightDate, "NYC", "LGB").scrape
	JBCollect.new(formattedFlightDate, "NYC", "MCO").scrape
	JBCollect.new(formattedFlightDate, "NYC", "FLL").scrape
	JBCollect.new(formattedFlightDate, "NYC", "BOS").scrape
end
puts "Finished Data Collection at " + Time.now.to_s
