require_relative 'jack/tokenizer'
require 'byebug'

path = ARGV.first

# compiler = Jack::Compiler.new(path)
# pp tokenizer.content

file = File.open(path)
tokenizer = Jack::Tokenizer.new(file)
pp tokenizer.traverse

# ruby tokenizer_test.rb ./mytest.jack