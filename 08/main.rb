require_relative 'file_translator'

path = ARGV.first

FileTranslator.new(path).translate


# ruby main.rb ./files/ProgramFlow/BasicLoop/BasicLoop.vm
# ruby main.rb ./files/ProgramFlow/FibonacciSeries/FibonacciSeries.vm
# ruby main.rb ./files/FunctionCalls/SimpleFunction/SimpleFunction.vm
# ruby main.rb ./files/FunctionCalls/FibonacciElement
# ruby main.rb ./files/FunctionCalls/StaticsTest
