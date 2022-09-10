require_relative 'parser'

module Jack
  class Compiler
    attr_accessor :file, :internal_paths, :grammar_file

    def initialize(target_path)
      @internal_paths = parse_internal_paths(target_path)
      @grammar_file = File.open("#{__dir__}/parser_grammar.yml")
      # @file = File.open(path)
      # @analizer = Analizer.new(file)
    end

    def compile
      internal_paths.map do |path|
        file = File.open(path)
        compile_file(file)
      end
    end

    private

    def parse_internal_paths(path)
      return [path] unless File.directory?(path)

      Dir
        .glob("#{path}/*")
        .select { |e| File.file?(e) && e.end_with?('.jack') }
    end

    def compile_file(file)
      parser = Parser.new(file, grammar_file)

      to_xml(parser.parse)
    end

    def to_xml(values_list = 'initial', indent_places = 0)
      skip_names = %w[type className subroutineName varName statement
                      subroutineCall identifier keywordConstant integerConstant
                      stringConstant op unaryOp].freeze
      values_list = parse if values_list == 'initial'

      result = ''
      values_list.each do |value_item|
        indentation = (' ' * 2) * indent_places
        if value_item[:values].nil?
          (result += "#{indentation}#{build_token_element(value_item)}\n")
          next
        end

        if skip_names.include?(value_item[:name])
          result += "#{to_xml(value_item[:values], indent_places)}\n"
          next
        end

        body = to_xml(value_item[:values], indent_places + 1)
        result += "#{indentation}<#{value_item[:name]}>\n"
        result += "#{body}\n"
        result += "#{indentation}</#{value_item[:name]}>\n"
      end

      result.delete_suffix("\n")
    end

    def build_token_element(token)
      tag = token[:name]
      "<#{tag}> #{token[:value]} </#{tag}>"
    end
  end
end
