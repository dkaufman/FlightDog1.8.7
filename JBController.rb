#This file gets the necessary date information for collecting the data
#It then passes that information to the JetBlue scraper, along with the airport information for each route

require 'JBCollect.rb'

def jbController
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
	begin
	JBCollect.new(formattedFlightDate, "BOS", "BWI").scrape
	rescue
		puts "***Failed to collect BOS to BWI for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BOS", "LGB").scrape
	rescue
		puts "***Failed to collect BOS to LGB for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BOS", "MCO").scrape
	rescue
		puts "***Failed to collect BOS to MCO for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BOS", "FLL").scrape
	rescue
		puts "***Failed to collect BOS to FLL for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BOS", "NYC").scrape
	rescue
		puts "***Failed to collect BOS to NYC for " + formattedFlightDate
	end
	
	
	puts "Scraping BWI for " + formattedFlightDate
	begin
	JBCollect.new(formattedFlightDate, "BWI", "BOS").scrape
	rescue
		puts "***Failed to collect BWI to BOS for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BWI", "LGB").scrape
	rescue
		puts "***Failed to collect BWI to LGB for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BWI", "MCO").scrape
	rescue
		puts "***Failed to collect BWI to MCO for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BWI", "FLL").scrape
	rescue
		puts "***Failed to collect BWI to FLL for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "BWI", "NYC").scrape
	rescue
		puts "***Failed to collect BWI to NYC for " + formattedFlightDate
	end


	puts "Scraping LGB for " + formattedFlightDate
	begin
	JBCollect.new(formattedFlightDate, "LGB", "BWI").scrape
	rescue
		puts "***Failed to collect LGB to BWI for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "LGB", "BOS").scrape
	rescue
		puts "***Failed to collect LGB to BOS for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "LGB", "MCO").scrape
	rescue
		puts "***Failed to collect LGB to MCO for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "LGB", "FLL").scrape
	rescue
		puts "***Failed to collect LGB to FLL for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "LGB", "NYC").scrape
	rescue
		puts "***Failed to collect LGB to NYC for " + formattedFlightDate
	end
	
	
	
	puts "Scraping MCO for " + formattedFlightDate
	begin
	JBCollect.new(formattedFlightDate, "MCO", "BWI").scrape
	rescue
		puts "***Failed to collect MCO to BWI for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "MCO", "LGB").scrape
	rescue
		puts "***Failed to collect MCO to LGB for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "MCO", "BOS").scrape
	rescue
		puts "***Failed to collect MCO to BOS for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "MCO", "FLL").scrape
	rescue
		puts "***Failed to collect MCO to FLL for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "MCO", "NYC").scrape
	rescue
		puts "***Failed to collect MCO to NYC for " + formattedFlightDate
	end



	puts "Scraping FLL for " + formattedFlightDate
	begin
	JBCollect.new(formattedFlightDate, "FLL", "BWI").scrape
	rescue
		puts "***Failed to collect FLL to BWI for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "FLL", "LGB").scrape
	rescue
		puts "***Failed to collect FLL to LGB for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "FLL", "MCO").scrape
	rescue
		puts "***Failed to collect FLL to MCO for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "FLL", "BOS").scrape
	rescue
		puts "***Failed to collect FLL to BOS for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "FLL", "NYC").scrape
	rescue
		puts "***Failed to collect FLL to NYC for " + formattedFlightDate
	end
	
	
	
	puts "Scraping NYC for " + formattedFlightDate
	begin
	JBCollect.new(formattedFlightDate, "NYC", "BWI").scrape
	rescue
		puts "***Failed to collect NYC to BWI for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "NYC", "LGB").scrape
	rescue
		puts "***Failed to collect NYC to LGB for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "NYC", "MCO").scrape
	rescue
		puts "***Failed to collect NYC to MCO for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "NYC", "FLL").scrape
	rescue
		puts "***Failed to collect NYC to FLL for " + formattedFlightDate
	end
	begin
	JBCollect.new(formattedFlightDate, "NYC", "BOS").scrape
	rescue
		puts "***Failed to collect NYC to BOS for " + formattedFlightDate
	end
end
puts "Finished Data Collection at " + Time.now.to_s
end