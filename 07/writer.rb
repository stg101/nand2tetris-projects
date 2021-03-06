require_relative 'arithmetic_transformer'
require_relative 'stack_ops_transformer'

class Writer
  attr_accessor :content, :output_path, :asm_lines, :pure_asm_lines

  include ArithmeticTransformer
  include StackOpsTransformer

  COMMAND_TYPES = {
    'add' => 'C_ARITHMETIC',
    'sub' => 'C_ARITHMETIC',
    'neg' => 'C_ARITHMETIC',
    'eq' => 'C_ARITHMETIC',
    'gt' => 'C_ARITHMETIC',
    'lt' => 'C_ARITHMETIC',
    'and' => 'C_ARITHMETIC',
    'or' => 'C_ARITHMETIC',
    'not' => 'C_ARITHMETIC',
    'push' => 'C_PUSH',
    'pop' => 'C_POP'
  }

  def initialize(output_path)
    @output_path = output_path
    @asm_lines = []
    @pure_asm_lines = []
  end

  def process(instr)
    instr_type = extract_type(instr)
    transformer_name = build_transformer_name(instr_type)

    @asm_lines << "// #{instr.join(' ')}"
    new_asm_lines = send(transformer_name, instr)
    @asm_lines.concat(with_line_numbers(new_asm_lines))
    @pure_asm_lines.concat(new_asm_lines)
  end

  def with_line_numbers(lines)
    lines.map.with_index { |l, i| "#{l} //    #{asm_counter + 1 + i}" }
  end

  def asm_counter
    pure_asm_lines.length - 1
  end

  def build_file
    clear_file
    write_lines(asm_lines)
  end

  private

  def clear_file
    File.open(output_path, 'w') { |f| f.write '' }
  end

  def write_lines(lines)
    File.open(output_path, 'a') do |f|
      lines.each do |l|
        f.write "#{l}\n"
      end
    end
  end

  def build_transformer_name(instr_type)
    "transform_#{instr_type[2..-1].downcase}"
  end

  def extract_type(instr)
    COMMAND_TYPES[instr[0]]
  end
end

# push constant 5

# @5
# D=A
# @SP
# A=M
# M=D
# @SP
# M=M+1

# add
# @SP
# M=M-1
# A=M
# D=M
# @SP
# M=M-1
# M=M-1
# A=M
# M=D+M
# @SP
# M=M+1

# .. M=D+M

# D*
# D++

# sub
# neg

# @SP
# M=M-1
# A=M
# M=!M
# @SP
# M=M+1

# eq
# gt
# lt
# and
# or
# not
