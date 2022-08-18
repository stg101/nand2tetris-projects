require_relative 'jack/parser'
require 'byebug'

path = ARGV.first

file = File.open(path)
parser = Jack::Parser.new(file)
puts parser.parse
