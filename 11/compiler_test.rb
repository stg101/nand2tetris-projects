require_relative 'jack/compiler'
require 'byebug'

path = ARGV.first
compiler = Jack::Compiler.new(path)

# puts compiler.internal_paths
begin
  pp compiler.compile
rescue => exception
  pp compiler.state[:instructions]
  raise exception
end
# pp compiler.subroutine_table
# pp compiler.class_table
# pp compiler.class_table
# pp compiler.subroutine_table

# puts compiler.compile.join("\n")