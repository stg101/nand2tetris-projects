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
# pp parser.parse_label('sequence')
# puts parser.parse_label('or_sequence')
# puts parser.parse_label('mixed1')
# puts parser.parse_label('mixed2')
# pp parser.parse_label('repeater')
pp parser.parse_label('opt')
