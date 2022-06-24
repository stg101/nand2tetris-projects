module ArithmeticTransformer
  def transform_arithmetic(instr)
    op = instr[0]

    send("#{op}_template")
  end

  def add_template
    ['@SP',
     'M=M-1',
     'A=M',
     'D=M',
     '@SP',
     'M=M-1',
     'M=M-1',
     'A=M',
     'M=D+M',
     '@SP',
     'M=M+1']
  end

  def not_template
    ['@SP',
     'M=M-1',
     'A=M',
     'M=!M',
     '@SP',
     'M=M+1']
  end
end
