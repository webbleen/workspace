require 'xcodeproj'

def addResouceToGroup(target, group, pathToXcode, pathToThisRb)
	Dir.foreach(pathToThisRb) do |entry|
	   if entry!='.' and entry!='..' and entry!='.DS_Store'
			new_classpath=File.join(pathToXcode,entry)
			file_rf = group.new_reference( new_classpath )
			target.add_resources([file_rf])
			puts "added resources file:#{new_classpath}"
	   end
	end
end

def addClassesToGroup(project, target, group, group_path, pathToXcode, pathToRb)
	
	Dir.foreach(pathToRb) do |entry|
	   if entry!='.' and entry!='..' and entry!='.DS_Store'
			new_pathToRb=File.join(pathToRb,entry)
			new_pathToXcode=File.join(pathToXcode,entry)
			new_group_path=File.join(group_path,entry)
			
			if File.file?( new_pathToRb ) 
				file_ext = File.extname( new_pathToRb )
				if  file_ext == '.c' or file_ext == '.h' or file_ext == '.cpp' or file_ext == '.hpp' or file_ext == '.cc'
					file_rf = group.new_reference( entry )
					target.add_file_references([file_rf])
					puts "added .cpp file:#{new_pathToXcode}"
				end
			elsif File::directory?( new_pathToRb )
				new_group = project.main_group.find_subpath(new_group_path, false)
				unless new_group
					new_group = group.new_group(entry,entry)
					puts "added group :#{new_group_path}"
				end
				#new_group.set_source_tree('SOURCE_ROOT')
				addClassesToGroup(project,target,new_group,new_group_path,new_pathToXcode, new_pathToRb)
			end
	   end
	end
end

puts "param1-xcodeprojfile:#{ARGV[0]}"
puts "param2-Classes_dir:#{ARGV[1]}"
puts "param3-Classes_dir_relative_to_xcode_path:#{ARGV[2]}"
puts "param4-Resources_dir:#{ARGV[3]}"
puts "param5-Resources_dir_relative_to_xcode_path:#{ARGV[4]}"

xcodepath = "#{ARGV[0]}"
project = Xcodeproj::Project.open(xcodepath)

# add classed to xcodeproject
target = project.targets.first  
groupClass = project.main_group.find_subpath(File.join('testpomelo','Classes'), true)  
groupClass.clear
group_path = File.join('testpomelo','Classes')
classesPathToXcode = "#{ARGV[2]}"
classesPathToRb = "#{ARGV[1]}"
#groupClass.set_source_tree('SOURCE_ROOT')

puts "begin add classes file reference to xcodeproject"
addClassesToGroup(project,target,groupClass,group_path,classesPathToXcode,classesPathToRb)
puts "end add classes file reference to xcodeproject"

#add resources to xcodeproject
resourcePathToXcode="#{ARGV[4]}"
resourcePathToThisRb="#{ARGV[3]}"
groupResources=project.main_group.find_subpath(File.join('testpomelo','Resources'), true)
groupResources.clear

puts "begin add resources reference to xcodeproject"
addResouceToGroup(target,groupResources,resourcePathToXcode,resourcePathToThisRb)
puts "end add resource reference to xcodeproject"

project.save
puts "ends xcodeproject config"