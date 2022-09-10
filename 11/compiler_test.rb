require_relative 'jack/compiler'
require 'byebug'

path = ARGV.first
compiler = Jack::Compiler.new(path)

# puts compiler.internal_paths
pp compiler.compile
# pp compiler.class_table
# pp compiler.subroutine_table
