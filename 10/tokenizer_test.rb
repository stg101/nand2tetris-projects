require_relative 'jack/tokenizer'
require 'byebug'

path = ARGV.first

# compiler = Jack::Compiler.new(path)
# pp tokenizer.content

# pp tokenizer.traverse

file = File.open(path)
tokenizer = Jack::Tokenizer.new(file)

File.open(path + "T.comp.xml", 'w') do |f|
  f.write(tokenizer.to_xml)
end


# ruby tokenizer_test.rb ./code/Square/SquareGame.jack
