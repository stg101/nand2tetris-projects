require_relative 'parser'
require_relative 'writer'

class FileTranslator
  attr_accessor :file, :parser, :writer

  def initialize(path)
    @file = File.open(path)
    @parser = Parser.new(@file)

    raise 'invalid file typle' unless path.end_with? '.vm'

    output_path = path.delete_suffix('.vm')
    output_path = "#{output_path}.asm"
    @writer = Writer.new(output_path)
  end

  def translate
    until parser.finished?
      instr = parser.parse_next
      writer.process(instr)
    end

    writer.build_file
  end
end
