require_relative 'parser'

class Coder
  attr_reader :instructions, :symbol_table

  def initialize(symbol_table, instructions)
    @symbol_table = symbol_table
    @instructions = instructions
  end

  def code
    instructions.map do |instr|
      transform instr
    end
  end

  private

  def transform(instr)
    if a_instruction? instr
      transform_a instr
    else
      transform_c instr
    end
  end

  def a_instruction?(instr)
    instr[0] == Parser::A_INSTRUCTION
  end

  def transform_a(instr)
    value = instr[1]
    value = symbol_table.table[value.to_sym] unless integer? value

    string2binary value
  end

  def transform_c(instr)
    operation_bits = OPERATIONS[instr[1]]
    destination_bits = DESTS[instr[2].to_s]
    jump_bits = JUMPS[instr[3].to_s]
    "111#{operation_bits}#{destination_bits}#{jump_bits}"
  end

  def integer?(str)
    str.to_i.to_s == str
  end

  def string2binary(str)
    bin_str = str.to_i.to_s(2)
    '0' * (16 - bin_str.length) + bin_str
  end

  OPERATIONS = {
    '0' => '0101010',
    '1' => '0111111',
    '-1' => '0111010',
    'D' => '0001100',
    'A' => '0110000',
    '!D' => '0001101',
    '!A' => '0110001',
    '-D' => '0001111',
    '-A' => '0110011',
    'D+1' => '0011111',
    'A+1' => '0110111',
    'D-1' => '0001110',
    'A-1' => '0110010',
    'D+A' => '0000010',
    'D-A' => '0010011',
    'A-D' => '0000111',
    'D&A' => '0000000',
    'D|A' => '0010101',
    'M' => '1110000',
    '!M' => '1110001',
    '-M' => '1110011',
    'M+1' => '1110111',
    'M-1' => '1110010',
    'D+M' => '1000010',
    'D-M' => '1010011',
    'M-D' => '1000111',
    'D&M' => '1000000',
    'D|M' => '1010101'
  }

  JUMPS = {
    '' => '000',
    'JGT' => '001',
    'JEQ' => '010',
    'JGE' => '011',
    'JLT' => '100',
    'JNE' => '101',
    'JLE' => '110',
    'JMP' => '111'
  }

  DESTS = {
    '' => '000',
    'M' => '001',
    'D' => '010',
    'MD' => '011',
    'A' => '100',
    'AM' => '101',
    'AD' => '110',
    'AMD' => '111'
  }
end
