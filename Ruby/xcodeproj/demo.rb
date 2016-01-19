require 'colorize'
require 'xcodeproj'
project_path = ARGV[0]
project = Xcodeproj::Project.open(project_path)

puts "所有的target名称：".green
project.targets.each do |target|
  puts target.name
end

target = project.targets.first

# Get all source files for a target
files = target.source_build_phase.files.to_a.map do |pbx_build_file|
  pbx_build_file.file_ref.real_path.to_s
end.select do |path|
  path.end_with?(".m", ".mm", ".swift")
end.select do |path|
  File.exists?(path)
end

files.each do |onefile|
  #puts onefile
end

puts "所有的buildseting：".green
target.build_configurations.each do |config|
  config.build_settings.each do |key, value|
    puts "[#{key}]:[#{value}]"
  end
end

