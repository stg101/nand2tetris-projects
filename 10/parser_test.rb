require_relative 'jack/parser'
require 'byebug'

path = ARGV.first

file = File.open(path)
grammar_file = File.open("./test_parser_grammar.yml")
parser = Jack::Parser.new(file, grammar_file)
# puts parser.parse

# puts parser.parse_token({type: 'token', value: 'class'})
# puts parser.parse_token({type: 'token', value: 'class'})
# puts parser.parse_token({type: 'token', name: 'identifier'})
puts parser.parse_pattern('sequence')
