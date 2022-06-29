module ArithmeticTransformer
  def transform_arithmetic(instr)
    op = instr[0]

    send("#{op}_template")
  end

  def add_template
    operation_helper('D+M')
  end

  def sub_template
    operation_helper('D-M')
  end

  def and_template
    operation_helper('D&M')
  end

  def or_template
    operation_helper('D|M')
  end

  def neg_template
    simple_operation_helper('-M')
  end

  def not_template
    simple_operation_helper('!M')
  end

  def eq_template
    compare_helper('JEQ')
  end

  def lt_template
    compare_helper('JLT')
  end

  def gt_template
    compare_helper('JGT')
  end

  private

  def compare_helper(asm_op)
    ['@SP',  # 1
     'M=M-1', # 2
     'A=M',  # 3
     'D=M',  # 4
     '@SP',  # 5
     'M=M-1', # 6
     'A=M', # 7
     'D=M-D', # 8
     "@#{asm_counter + 16}", # 9
     "D;#{asm_op}", # 10
     '@SP',  # 11
     'A=M',  # 12
     'M=0',  # 13
     "@#{asm_counter + 19}", # 14
     '0;JMP', # 15
     '@SP',  # 16
     'A=M',  # 17
     'M=-1', # 18
     '@SP', # 19
     'M=M+1']  # 20
  end

  def operation_helper(asm_op)
    ['@SP',
     'M=M-1',
     'A=M',
     'D=M',
     '@SP',
     'M=M-1',
     'A=M',
     "M=#{asm_op}",
     '@SP',
     'M=M+1']
  end

  def simple_operation_helper(asm_op)
    ['@SP',
     'M=M-1',
     'A=M',
     "M=#{asm_op}",
     '@SP',
     'M=M+1']
  end
end
