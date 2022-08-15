require_relative 'jack/tokenizer'
require 'byebug'

path = ARGV.first

# compiler = Jack::Compiler.new(path)
# pp tokenizer.content

file = File.open(path)
grammar_file = File.open('./tokenizer_grammar.yml')
tokenizer = Jack::Tokenizer.new(file, grammar_file)

File.open(path + ".comp", 'w') do |f|
  f.write(tokenizer.to_xml)
end
