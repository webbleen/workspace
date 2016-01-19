file = File.open("simple_grep.rb")
begin
  file.each_line do |line|
    print line
  end
ensure
  file.close
end
