require_relative 'jack/tokenizer'
require 'byebug'

path = ARGV.first

file = File.open(path)
tokenizer = Jack::Tokenizer.new(file)

while tokenizer.more_tokens?
  puts tokenizer.advance
end

# ruby tokenizer_test.rb ./code/Square/Main.jack

#############################

# compiler = Jack::Compiler.new(path)
# pp tokenizer.content

# pp tokenizer.traverse


### DIR WRITER

# dir_path = ARGV.first


# def write_output(path, tokenizer)
#   File.open(path + 'T.comp.xml', 'w') do |f|
#     f.write(tokenizer.to_xml)
#   end
# end


# file_paths = Dir
#              .glob("#{dir_path}/*")
#              .select { |e| File.file?(e) && e.end_with?('.jack') }


# file_paths.each do |path|
#   file = File.open(path)
#   tokenizer = Jack::Tokenizer.new(file)
#   write_output(path, tokenizer)
# end

############

# ruby tokenizer_test.rb ./code/Square
