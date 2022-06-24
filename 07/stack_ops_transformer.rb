module StackOpsTransformer
  def transform_push(instr)
    _op, _segment, value = instr

    ["@#{value}",
     'D=A',
     '@SP',
     'A=M',
     'M=D',
     '@SP',
     'M=M+1']
  end
end
