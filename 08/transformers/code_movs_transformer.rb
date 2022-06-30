module CodeMovsTransformer
  def transform_label(instr)
    ["(#{instr[1]})"]
  end

  def transform_goto(_instr)
    []
  end

  def transform_if(instr)
    ['@SP',
     'A=M-1',
     'D=M',
     "@#{instr[1]}",
     'D;JNE']
  end
end

# if-goto LOOP_START

# ['@SP',
#   'A=M-1',
#   'D=M',
#   '@LOOP_START',
#   'D;JNE']
