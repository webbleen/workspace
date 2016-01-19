#!/usr/bin/ruby

def simple_grep(pattern, filename)
	file = File.open(filename)
	count = 1
	file.each_line do |line|
		if pattern =~ line
			print "#{count}:#{line}"
		end
		count = count + 1
	end
	file.close
end
