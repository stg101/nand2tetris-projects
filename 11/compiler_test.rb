require_relative 'jack/compiler'
require 'byebug'

path = ARGV.first
compiler = Jack::Compiler.new(path)

# puts compiler.internal_paths
pp compiler.compile
