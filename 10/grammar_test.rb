require_relative 'jack/grammar'
require 'byebug'
require 'yaml'

path = ARGV.first

# compiler = Jack::Compiler.new(path)
# pp tokenizer.content

grammar_file = File.open('./parser_grammar.yml')
grammar = Jack::Grammar.new(grammar_file)

print grammar.parse.to_yaml

# File.open(path + ".comp", 'w') do |f|
#   f.write(tokenizer.to_xml)
# end


# a = {a:1, c: {b: [[], 'a']}}

#  grammar.tree_insert!(a, [:c , :b, 0], "asdasd")
#  grammar.tree_insert!(a, [:c , :b, 0], "asdasd")

#  puts a


# p grammar.parse_pattern("'too'")
# p grammar.parse_pattern("'too' 'too' 'too'")
# pp grammar.parse_pattern("'too' 'too' ('too''too')")
# pp grammar.parse_pattern("too ('too' | too)* 'too'")


# pp grammar.parse_pattern("('constructor' | 'function' | 'method') ('void' | type) subroutineName '(' parameterList ')' subroutineBody")
# pp grammar.parse_pattern("(expression (','expression)*)?")

# pp grammar.parse_pattern("('static' | 'field' ) type varName (',' varName)* ';'")





