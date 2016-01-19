#!/usr/bin/ruby

class Customer
	@@no_of_customers=0;
	def initialize(id, name, addr)
		@cust_id=id
		@cust_name=name
		@cust_addr=addr

		puts @cust_id<<' '<<@cust_name<<' '<<@cust_addr
	end

	def Hello
      puts "Hello Ruby!"
   end
end

cust1=Customer. new("1", "John", "Wisdom Apartments, Ludhiya")
cust1.Hello

cust2=Customer. new("2", "Poul", "New Empire road, Khandala")
cust2.Hello
