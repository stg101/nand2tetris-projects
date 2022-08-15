require_relative 'jack/tokenizer'
require 'byebug'

dir_path = ARGV.first

# compiler = Jack::Compiler.new(path)
# pp tokenizer.content

# pp tokenizer.traverse

def write_output(path, tokenizer)
  File.open(path + 'T.comp.xml', 'w') do |f|
    f.write(tokenizer.to_xml)
  end
end


file_paths = Dir
             .glob("#{dir_path}/*")
             .select { |e| File.file?(e) && e.end_with?('.jack') }


file_paths.each do |path|
  file = File.open(path)
  tokenizer = Jack::Tokenizer.new(file)
  write_output(path, tokenizer)
end

# ruby tokenizer_test.rb ./code/Square
