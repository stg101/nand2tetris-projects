require_relative 'stack_ops_transformer'
require_relative 'code_movs_transformer'

module FuncionOpsTransformer
  include StackOpsTransformer
  include CodeMovsTransformer

  #   vm : function SimpleFunction.test 2
  def transform_function(instr)
    push_count = instr[2].to_i
    result = []

    push_count.times { result << transform_push(%w[push constant 0]) }

    result.flatten
  end

  def transform_call(_instr) ## TODO : Complete impl
    @function_counter ||= {}
    func_name = instr[1]
    @call_counter[func_name] = (@call_counter[func_name] || -1) + 1

    label = "#{file_name}.#{func_name}$ret.#{@call_counter[func_name]}"

    [*transform_push(%w[push constant LCL]),
     *transform_push(%w[push constant ARG]),
     *transform_push(%w[push constant THIS]),
     *transform_push(%w[push constant THAT]),
     *transform_label(['label', label])]
  end

  def transform_return(_instr)
    [
      '@LCL',
      'D=M',
      *pseudo_assign('endFrame', 'D'),
      *pseudo_sub_redirect_assign('endFrame', '5', 'retAddr'),
      *transform_pop(%w[pop argument 0]),
      *pseudo_add('ARG', '1'),
      *pseudo_assign('SP', 'D'),
      *pseudo_sub_redirect_assign('endFrame', '1', 'THAT'),
      *pseudo_sub_redirect_assign('endFrame', '2', 'THIS'),
      *pseudo_sub_redirect_assign('endFrame', '3', 'ARG'),
      *pseudo_sub_redirect_assign('endFrame', '4', 'LCL'),
      '@retAddr', 'A=M', '0;JMP'
    ]
  end

  private

  def pseudo_sub_redirect_assign(input, val, output)
    [*pseudo_sub(input, val),
     *pseudo_redirect,
     *pseudo_assign(output, 'D')]
  end

  def pseudo_redirect
    ['A=D',
     'D=M']
  end

  def pseudo_add(symbol, value)
    ["@#{value}", 'D=A', "@#{symbol}", 'D=D+M']
  end

  def pseudo_sub(symbol, value)
    ["@#{value}", 'D=A', "@#{symbol}", 'D=M-D']
  end

  def pseudo_assign(left, right)
    ["@#{left}", "M=#{right}"]
  end
end
