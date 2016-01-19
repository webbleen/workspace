#!/usr/bin/ruby

#字串常值
puts 'escape using ""';
puts 'That\'s right';

print "\n===========================================\n"
#表达式
puts "Multiplication Value : #{24*60*60}"

print "\n===========================================\n"
#数组
array = ["fred", 10, 3.14, "This is a string", "last element", ]
array.each do |i|
	puts i
end

print "\n===========================================\n"
#哈希
hash = colors = { "red" => 0xf00, "green" => 0x0f0, "blue" => 0x00f }
hash.each do |key, value|
	print key, " is ", value, "
"
end

print "\n===========================================\n"
#范围
(10..15).each do |n|
	print n, ' '
end

print "\n===========================================\n"
(10...15).each do |n|
	print n, ' '
end

print "\n===========================================\n"
# 双冒号
CONST = ' out there'
class Inside_one
	CONST =proc {' in there'}
	def where_is_my_CONST
		::CONST + ' inside one'
	end
end

class Inside_two
	CONST =proc {' in there'}
	def where_is_my_CONST
		::CONST + ' inside two'
	end
end

puts Inside_one. new.where_is_my_CONST
puts Inside_two. new.where_is_my_CONST
puts Object::CONST + Inside_two::CONST
puts Inside_two::CONST + CONST
puts Inside_one::CONST
puts Inside_one::CONST.call + Inside_two::CONST



print "\n===========================================\n"
