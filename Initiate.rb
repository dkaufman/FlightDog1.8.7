#This script calls the controllers for each airline's website
#It calls the scripts multiple times, sleeping for 6 hours in between each run

require 'atController.rb'
require 'jbController.rb'

#Constants
TimesToRepeat = 1
HoursToWait = 17

secondsToWait = HoursToWait*3600

puts "Waiting " + HoursToWait.to_s + " hours"
sleep(secondsToWait)
puts "Waited " + HoursToWait.to_s + " hours"

puts "Beginning Collection"
#Repeat scripts for designated number of times with designated interval between
for i in (1..TimesToRepeat)
	#List each airline's controller script here
	atController()
	jbController()
	
	#Script sleeps until this is the last time it needs to run
	if i != TimesToRepeat
		puts "Waiting " + HoursToWait.to_s + " hours"
		sleep(secondsToWait)
		puts "Waited " + HoursToWait.to_s + " hours"
	end
end




