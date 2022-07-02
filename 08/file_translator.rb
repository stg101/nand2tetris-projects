require_relative 'parser'
require_relative 'writer'

class FileTranslator
  attr_accessor :file, :parsers, :writer, :output_path

  def initialize(path)
    @parsers = build_parsers(path)
    @writer = Writer.new(@output_path)
  end

  def translate
    parsers.each do |parser|
      writer.input_path = parser.file_path

      until parser.finished?
        instr = parser.parse_next
        writer.process(instr)
      end
    end

    writer.build_file
  end

  private

  def build_parsers(path)
    is_dir = File.directory?(path)
    is_file = File.file?(path)

    if is_file
      raise 'invalid file typle' unless path.end_with? '.vm'

      file = File.open(path)
      @output_path = path.delete_suffix('.vm')
      @output_path = "#{output_path}.asm"

      [Parser.new(file)]
    elsif is_dir
      @output_path = "#{path}/Main.asm"

      Dir
        .glob("#{path}/*")
        .select { |e| File.file?(e) && e.end_with?('.vm') }
        .map { |p| Parser.new(File.open(p)) }
    end
  end
end

# File.directory?("name") and/or File.file?("name")
# files/FunctionCalls/FibonacciElement
# files/FunctionCalls/FibonacciElement/Main.vm
