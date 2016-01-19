File.open("simple_grep.rb") do |file|
  file.each_line do |line|
    print line
  end
end
