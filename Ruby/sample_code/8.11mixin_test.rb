#! /usr/bin/ruby
#
module M
  def meth
    "meth"
  end
end

class C
  include M
end

c = C.new
p c.meth

p C.include?(M)
p C.ancestors
p C.superclass
