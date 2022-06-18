require_relative 'symbol_table'
require 'forwardable'

class Parser
  attr_reader :symbol_table, :content
  attr_accessor :instructions

  extend Forwardable
  def_delegator :@symbol_table, :table, :table

  C_INSTRUCTION = 'c_instruction'.freeze
  A_INSTRUCTION = 'a_instruction'.freeze

  def initialize(file)
    @content = clean(file.readlines)
    @symbol_table = SymbolTable.new
    @instructions = []
  end

  def parse
    result_text = first_run(content)
    @instructions = second_run(result_text)

    instructions
  end

  private

  def clean(text)
    text.map do |line|
      new_line = clean_line(line)
      next nil if new_line.empty?

      new_line
    end.compact
  end

  def first_run(text)
    line_counter = 0
    result_text = []

    text.each do |line|
      if label? line
        label = parse_label(line)
        symbol_table.add_pair(label, line_counter)
      else
        line_counter += 1
        result_text << line
      end
    end

    result_text
  end

  def second_run(text)
    text.map do |line|
      parse_intruction line
    end
  end

  def clean_line(str)
    str.split('//').first.gsub(/\s/, '')
  end

  def label?(str)
    str[0] == '(' && str[-1] == ')'
  end

  def parse_label(str)
    str[1..-2].to_sym
  end

  def parse_intruction(instr)
    if a_instruction? instr
      parse_a_instruction instr
    else
      parse_c_instruction instr
    end
  end

  def a_instruction?(str)
    str[0] == '@'
  end

  def parse_a_instruction(str)
    key = str[1..-1]
    symbol_table.add_key(key.to_sym) if add_key? key

    [A_INSTRUCTION, key]
  end

  def c_instruction?(str)
    !a_instruction?(str)
  end

  def parse_c_instruction(str)
    assignment, jump = str.split(';')
    assignment_arr = assignment.split('=')

    if assignment_arr.length == 1
      operation = assignment_arr[0]
    else
      destination, operation = assignment_arr
    end

    [C_INSTRUCTION, operation, destination, jump]
  end

  def add_key?(key)
    !symbol_table.key?(key.to_sym) && !integer?(key)
  end

  def integer?(str)
    str.to_i.to_s == str
  end
end
