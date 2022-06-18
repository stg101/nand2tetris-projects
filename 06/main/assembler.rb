require_relative 'parser'
require_relative 'coder'

path = ARGV.first

class Assembler
  attr_reader :file

  def initialize(path)
    @file = File.open(path)
  end

  def assemble
    parser = Parser.new(file)
    parser.parse

    coder = Coder.new(
      parser.symbol_table,
      parser.instructions
    )

    coder.code
  end
end
