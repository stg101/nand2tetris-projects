module StackOpsTransformer
  SEGMENT_MAPPING = {
    'local' => 'LCL',
    'argument' => 'ARG',
    'this' => 'THIS',
    'that' => 'THAT'
  }

  TEMP_BASE_ADDR = 5

  def static_prefix
    file_name
  end

  def transform_push(instr)
    _op, segment, value = instr

    seg_val = ["@#{SEGMENT_MAPPING[segment]}", 'D=M'] if SEGMENT_MAPPING.key? segment
    seg_val = ["@#{TEMP_BASE_ADDR}", 'D=A'] if segment == 'temp'

    seg_val2 = [*seg_val, "@#{value}", 'A=D+A', 'D=M']
    seg_val2 = ["@#{value}", 'D=A'] if segment == 'constant'
    seg_val2 = ["@#{static_prefix}.#{value}", 'D=M'] if segment == 'static'
    seg_val2 = ["@#{value == '0' ? 'THIS' : 'THAT'}", 'D=M'] if segment == 'pointer'

    [*seg_val2,
     '@SP',
     'A=M',
     'M=D',
     '@SP',
     'M=M+1']
  end

  def transform_pop(instr)
    _op, segment, value = instr

    seg_val = ["@#{SEGMENT_MAPPING[segment]}", 'D=M'] if SEGMENT_MAPPING.key? segment
    seg_val = ["@#{TEMP_BASE_ADDR}", 'D=A'] if segment == 'temp'

    if segment == 'static'

      return ['@SP',
              'A=M-1',
              'D=M',
              "@#{static_prefix}.#{value}",
              'M=D',
              '@SP',
              'M=M-1']
    end

    if segment == 'pointer'

      return ['@SP',
              'A=M-1',
              'D=M',
              "@#{value == '0' ? 'THIS' : 'THAT'}",
              'M=D',
              '@SP',
              'M=M-1']
    end

    [
      *seg_val,
      "@#{value}",
      'D=D+A',
      '@addr',
      'M=D',
      '@SP',
      'A=M-1',
      'D=M',
      '@addr',
      'A=M',
      'M=D ',
      '@SP',
      'M=M-1'
    ]
  end
end

# LCL: 1,
# ARG: 2,
# THIS: 3,
# THAT: 4,

# pop pointer 0

# @SP
# A=M-1
# D=M
# @THIS
# M=D
# @SP
# M=M-1

# push pointer 0

# @THIS
# D=M
# @SP
# A=M
# M=D
# @SP
# M=M+1

# pop static 5

# @SP
# A=M-1
# D=M
# @PointerTest.5
# M=D
# @SP
# M=M-1

# push static 5

# @PointerTest.5
# D=M
# @SP
# A=M
# M=D
# @SP
# M=M+1

# # pop temp 7
# @5
# D=A
# @7
# D=D+A
# @addr
# M=D
# @SP
# A=M-1
# D=M
# @addr
# A=M
# M=D
# @SP
# M=M-1

# # pop local 7
# @LCL
# D=M
# @7
# D=D+A
# @addr
# M=D
# @SP
# A=M-1
# D=M
# @addr
# A=M
# M=D
# @SP
# M=M-1

# # push local 5
# @LCL
# D=M
# @5
# A=D+A
# D=M
# @SP
# A=M
# M=D
# @SP
# M=M+1
