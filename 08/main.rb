require_relative 'file_translator'

path = ARGV.first

FileTranslator.new(path).translate


# ruby main.rb ./files/ProgramFlow/BasicLoop/BasicLoop.vm
# ruby main.rb ./files/ProgramFlow/FibonacciSeries/FibonacciSeries.vm