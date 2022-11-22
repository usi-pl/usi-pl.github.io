all: rb
	@true

rb: schedule.html

schedule.html: schedule.rb scheduler.rb
	ruby schedule.rb > schedule.html

