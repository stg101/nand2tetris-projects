require_relative 'jack/tokenizer'
require 'byebug'

path = ARGV.first

# compiler = Jack::Compiler.new(path)
# pp tokenizer.content

file = File.open(path)
grammar_file = File.open("./tokenizer_grammar.yml")
tokenizer = Jack::Tokenizer.new(file, grammar_file)
# puts tokenizer.to_xml

# while !tokenizer.finished? do
#   tokenizer.advance
# end

puts tokenizer.to_xml

# ruby main.rb ./files/ProgramFlow/BasicLoop/BasicLoop.vm
# ruby main.rb ./code/Square/SquareGame.jack

# compiler 
# [
    # analizer [
    #   tokenizer
    #   parser
    # ]
    # code generator
# ]