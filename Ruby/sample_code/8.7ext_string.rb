#! /usr/bin/ruby

class String
	def count_word
		ary = self.split(/\s+/)	# 用空格分隔接收者
		return ary.size			# 返回分割后的数组的元素个数
	end
end

str = "Just Another Ruby Newbie"
p str.count_word