#!/usr/bin/ruby

pattern = Regexp.new(ARGV[0])

filename = ARGV[1]

file = File.open(filename)
count = 1
file.each_line do |line|
	if pattern =~ line
		print "#{count}:#{line}"
	end
	count = count + 1
end

file.close