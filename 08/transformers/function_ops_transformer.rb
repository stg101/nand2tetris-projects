require_relative 'stack_ops_transformer'
require_relative 'code_movs_transformer'

module FuncionOpsTransformer
  include StackOpsTransformer
  include CodeMovsTransformer

  def transform_function(instr)
    push_count = instr[2].to_i
    result = []
    push_count.times { result << transform_push(%w[push constant 0]) }

    [*transform_label(['label', instr[1]]), *result.flatten]
  end

  def transform_call(instr)
    func_name = instr[1]
    n_args = instr[2]
    @call_counter ||= {}
    @call_counter[func_name] = (@call_counter[func_name] || -1) + 1

    label = "#{func_name}$ret.#{@call_counter[func_name]}"

    [*push_label(label),
     *push_symbol('LCL'),
     *push_symbol('ARG'),
     *push_symbol('THIS'),
     *push_symbol('THAT'),
     *pseudo_sub('SP', '5'),
     *pseudo_assign('temp_diff', 'D'),
     *pseudo_sub('temp_diff', n_args),
     *pseudo_assign('ARG', 'D'),
     *pseudo_assign_symbol('LCL', 'SP'),
     *transform_goto(['goto', func_name]),
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

  def pseudo_assign_symbol(left, right)
    ["@#{right}",
     'D=M',
     "@#{left}",
     'M=D']
  end

  def push_symbol(symbol)
    [
      "@#{symbol}",
      'D=M',
      '@SP',
      'A=M',
      'M=D',
      '@SP',
      'M=M+1'
    ]
  end

  def push_label(label)
    [
      "@#{label}",
      'D=A',
      '@SP',
      'A=M',
      'M=D',
      '@SP',
      'M=M+1'
    ]
  end
end
