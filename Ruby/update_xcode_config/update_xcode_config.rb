#!/usr/bin/ruby

require 'xcodeproj'

# Usage:
# ruby update_xcode_config.rb -p <path/to/xcode_project> -t <Target> -n <product_name> -m ['Automatic' | 'Manual'] -m ['com.apple.InAppPurchase,0']

class Options
  attr_accessor :path, :target, :name, :method, :capabilities

  def initialize(args)
    @path = args[:path] || Dir.glob("*.xcodeproj").first
    @target = args[:target]
    @name = args[:name]
    @method = args[:method]
    @capabilities = args[:capabilities]
  end
end

def parse_args
  options_hash = {}
  args = ARGV
  args.each_with_index do |arg, index|
    case arg
      when '--project_path', '-p'
        path = args[index + 1]
        unless File.exist?(path)
          abort('There is no file at specified path.')
        end
        options_hash[:path] = path
      when '--target', '-t'
        options_hash[:target] = args[index + 1]
      when '--product_name', '-n'
        options_hash[:name] = args[index + 1]
      when '--signing_method', '-m'
        method = args[index + 1]
        unless ['Automatic', 'Manual'].include?(method)
          abort("'Invalid signing method specified. Please use either 'Automatic' or 'Manual'")
        end
        options_hash[:method] = method
      when '--capabilities', '-c'
        capabilities = {}
        capabilitie_array = args[index + 1].split(";")
        capabilitie_array.each { |item|
          item_array = item.split(",")
          if(item_array.size == 2)
            item_hash = { "enabled" => item_array[1]}
            capabilities.store(item_array[0], item_hash)
          end
        }
        options_hash[:capabilities] = capabilities
    end
  end

  options_hash
end

options = Options.new parse_args

puts "path: '#{options.path}'.\n"
puts "target: '#{options.target}'.\n"
puts "name: '#{options.name}'.\n"
puts "method: '#{options.method}'.\n"
puts "capabilities: '#{options.capabilities}'.\n"

project = Xcodeproj::Project.open(options.path)

project.build_configuration_list.set_setting('PRODUCT_NAME', options.name)
project.targets.each do |target|
  target.build_configuration_list.set_setting('PRODUCT_NAME', options.name)
end

target_id = project.targets.select {|target| target.name == options.target }.first.uuid
attributes = project.root_object.attributes['TargetAttributes']
target_attributes = attributes[target_id]
if target_attributes == nil
  provision_attributes = Hash['ProvisioningStyle' => options.method]
  attributes[target_id] = provision_attributes
else
  target_attributes['ProvisioningStyle'] = options.method
  capabilities = target_attributes['SystemCapabilities']
  capabilities.each do |k1|
    options.capabilities.each { |k2|
      if k1 == k2
        capabilities[k1] = options.capabilities[k2]
      end
    }
  end
end

project.sort
project.save
