require 'Xcodeproj'
require 'fileutils'
require 'fir'

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

def addFolderToGroup(project, target, group, groupPath, folderPath)
  Dir.foreach(folderPath) do |entry|
    if entry != '.' and entry != '..' and entry != '.DS_Store'
      new_pathToRb = File.join(folderPath, entry)
      new_group_path = File.join(groupPath, entry)

      if File.file?( new_pathToRb )
        #file_ext = File.extname( new_pathToRb )
        file_ref = group.new_reference( entry )
        target.add_file_references([file_ref])
        puts "add file: #{new_pathToRb}"
      elsif File.directory?( new_pathToRb )
        new_group = project.main_group.find_subpath(new_group_path, false)
        unless new_group
          new_group = group.new_group(entry,entry)
          puts "added group :#{new_group_path}"
        end
        addFolderToGroup(project, target, new_group, new_group_path, new_pathToRb)
      end
    end
  end
end


puts Xcodeproj::VERSION

Xcodeproj::UI.puts("standard output!")
Xcodeproj::UI.warn("standard error!")


xcode_path = "/Users/linekong/xcodeproject"
src_xcode = "xcode_sszj_th_app"

child_name = "ruby"

dest_xcode = "xcode_sszj_th_" + child_name

Dir.chdir(xcode_path)
puts Dir.pwd
# 清空目录#
FileUtils.rmtree(dest_xcode) if File.exist?(dest_xcode)
# 创建文件夹#
Dir.mkdir(dest_xcode) unless File.exist?(dest_xcode)

# 复制文件夹
FileUtils.cp_r(src_xcode + '/.', dest_xcode)

dest_xcode_path = xcode_path + File::Separator + dest_xcode


project = Xcodeproj::Project.open("/Users/linekong/xcodeproject/xcode_sszj_th_ruby/Unity-iPhone.xcodeproj")

target = project.targets.first
puts target.name

groupClass = project.main_group.find_subpath(File.join('crasheye'), true)
groupClass.clear
groupPath = File.join('crasheye')
classPath = "/Users/linekong/xcodeproject/xcode_sszj_th_ruby/crasheye"

addFolderToGroup(project, target, groupClass, groupPath, classPath)
#puts "begin add classes file reference to xcodeproject"
#addClassesToGroup(project,target,groupClass,group_path,classesPathToXcode,classesPathToRb)
#puts "end add classes file reference to xcodeproject"


puts project.to_s()

project.save()
