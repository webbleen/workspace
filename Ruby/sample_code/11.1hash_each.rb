#! /usr/bin/ruby

sum = 0

outcome = { "参加费"=>1000, "挂件费用"=>1000, "联欢会费用"=>4000 }
outcome.each do |pair|
	sum += pair[1]	#指定值
end

puts " 合计1：#{sum}"


sum = 0
outcome.each do |item, price|
	sum += price
end

puts " 合计2：#{sum}"