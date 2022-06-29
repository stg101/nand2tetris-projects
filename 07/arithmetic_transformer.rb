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
    ['@SP',
     'M=M-1',
     'A=M',
     'D=M',
     '@SP',
     'M=M-1',
     'A=M',
     'D=D-M',
     "@#{asm_counter + 13}",
     "D;#{asm_op}",
     '@SP',
     'M=0',
     '@SP',
     'M=-1',
     '@SP',
     'M=M+1']
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
