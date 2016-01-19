#!/usr/bin/ruby

class HelloWorld
	attr_accessor :name

	def initialize(myname = "Ruby")
		@name = myname		#初始化实例变量
	end

	def hello
		puts "Hello, world. I am #{@name}."
	end
=begin
	def name
		@name
	end

	def name=(value)
		@name = value
	end
=end
	def greet
		puts "Hi, I am #{self.name}"
		
	end
end

bob = HelloWorld.new("Bob")
alice = HelloWorld.new("Alice")
ruby = HelloWorld.new

bob.hello
alice.hello
ruby.hello

p bob.name

bob.name = "Report"
bob.hello

bob.greet