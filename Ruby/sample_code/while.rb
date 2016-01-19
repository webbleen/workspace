#!/usr/bin/ruby

i = 1

while i <= 10 do
	print i, "\n"
	i = i + 1	
end

100.times do
	print "All work and no play makes Jack a dull boy.\n"
end

sym = :foo
print sym, "\n"
print sym.to_s, "\n"

str = "foo"
print str.to_sym, "\n"

#散列
address = { :name => "高桥", :pinyin => "gaoqiao", :postal => "000-1234-5678" }
puts address
#print address[:name], "\n"
#print address[:pinyin], "\n"
#print address[:postal], "\n"
address.each do |key, value|
	puts "#{key}: #{value}"
end
