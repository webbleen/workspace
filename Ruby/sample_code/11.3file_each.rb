file = File.open("simple_grep.rb")
file.each_line do |line|
  print line
end
file.close
