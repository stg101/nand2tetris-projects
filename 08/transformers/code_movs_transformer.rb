module CodeMovsTransformer
  def transform_label(instr)
    ["(#{instr[1]})"]
  end

  def transform_goto(_instr)
    []
  end

  def transform_if(_instr)
    ['@SP',
     'A=M-1',
     'D=M+1',
     '@LOOP_START',
     'D;JEQ']
  end
end

# if-goto LOOP_START
# "@SP",
# "A=M-1",
# "D=M+1",
# "@LOOP_START",
# "D;JEQ",
