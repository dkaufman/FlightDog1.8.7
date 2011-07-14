FLightDog1.8.7 is a script designed to collect data on airline pricing for one-way flights over the next month.
It is launched by running the initiate.rb file, which allows the user to control the number of time it repeats and how long it should wait between collections. Additionally, the user can change the routes that the script collects in the controller files.

Currently, the script has been developed for AirTran and JetBlue.

Its name is such because it currently only works for Ruby 1.8.7 (the Mechanize gem in this version seems to be able to infer the location of the AirTran submit button, even though it is in Javascript).

Next steps for the script are as follows:
	1) Rewrite the ATCollect script to work in the newest version of Ruby
	2) Refactor to eliminate duplicate code
	3) Write data to Amazon SimpleDB as opposed to a local file
	4) Insert code to allow script to run on a recurring basis on SimpleWorker
	