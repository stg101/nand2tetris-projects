require_relative 'file_translator'

path = ARGV.first

FileTranslator.new(path).translate


# ruby main.rb ./spec/support/gradding_tests/StackArithmetic/SimpleAdd/SimpleAdd.vm