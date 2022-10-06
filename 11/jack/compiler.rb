require_relative 'parser'
require_relative 'symbol_table'

module Jack
  class Compiler
    attr_accessor :file, :internal_paths, :grammar_file,
                  :state, :class_table, :subroutine_table

    def initialize(target_path)
      @internal_paths = parse_internal_paths(target_path)
      @grammar_file = File.open("#{__dir__}/parser_grammar.yml")
      @class_table =  SymbolTable.new
      @subroutine_table = SymbolTable.new
      # @instructions = []
      # @file = File.open(path)
      # @analizer = Analizer.new(file)

      @state = {
        classname: '',
        instructions: []
      }
    end

    def compile
      internal_paths.each do |path|
        file = File.open(path)
        vm_path = path.delete_suffix('.jack').concat('.vm')
        vm_code = compile_file(file).join("\n")
        File.open(vm_path, 'w') { |f| f.write vm_code }
      end
    end

    private

    def parse_internal_paths(path)
      return [path] unless File.directory?(path)

      Dir
        .glob("#{path}/*")
        .select { |e| File.file?(e) && e.end_with?('.jack') }
    end

    def compile_file(file)
      state[:instructions] = []
      parser = Parser.new(file, grammar_file)
      # parser.parse
      c_class(parser.parse[0])
      state[:instructions]
    end

    def c_class(ast)
      class_name_ast = child_by_name(ast, 'className')
      state[:classname] = class_name_ast[:values][0][:values][0][:value]
      varDecs = children_by_name(ast, 'classVarDec')
      varDecs.each do |dec|
        c_class_var_dec(dec)
      end

      subroutineDecs = children_by_name(ast, 'subroutineDec')
      subroutineDecs.each do |dec|
        c_subroutine_dec(dec)
      end
    end

    def c_subroutine_dec(ast) # TODO: add this argument
      subroutine_table.refresh
      name = drill_by_names(ast, %w[subroutineName identifier identifier])[:value]
      classname = state[:classname]

      body_ast = child_by_name(ast, 'subroutineBody')
      params_ast = child_by_name(ast, 'parameterList')
      var_decs = children_by_name(body_ast, 'varDec')

      c_parameter_list(params_ast)
      inst = "function #{classname}.#{name} #{var_decs.length}"
      push_instruction inst

      var_decs.each do |dec|
        c_subroutine_var_dec(dec)
      end

      statements = child_by_name(body_ast, 'statements')[:values]
      statements.each do |s|
        c_statement(s)
      end
    end

    def c_statement(ast)
      statement = ast[:values][0]
      type = statement[:name]

      case type
      when 'letStatement'
        c_let_statement(statement)
      when 'doStatement'
        c_do_statement(statement)
      when 'returnStatement'
        c_return_statement(statement)
      when 'ifStatement'
        c_if_statement(statement)
      when 'whileStatement'
        c_while_statement(statement)
      end
    end

    def c_while_statement(ast)
      # pp '******'
      # pp ast
      # pp '******'
      label1 = unique_label('L1-while')
      label2 = unique_label('L2-while')

      condition_ast = child_by_name(ast, 'expression')
      statements_ast = child_by_name(ast, 'statements')

      push_instruction("label #{label1}")
      c_expression(condition_ast)
      push_instruction('not')
      push_instruction("if-goto #{label2}")
      statements_ast[:values].each { |s| c_statement(s) }
      push_instruction("goto #{label1}")
      push_instruction("label #{label2}")
    end

    def c_if_statement(ast)
      label1 = unique_label('L1-if')
      label2 = unique_label('L2-if')

      condidion_bodies = children_by_name(ast, 'statements')

      if_statements = condidion_bodies[0]
      else_statements = condidion_bodies[1]

      condition_ast = child_by_name(ast, 'expression')
      c_expression(condition_ast)
      push_instruction('not')
      push_instruction("if-goto #{label1}")
      if_statements[:values].each { |s| c_statement(s) }
      push_instruction("goto #{label2}")
      push_instruction("label #{label1}")
      else_statements[:values].each { |s| c_statement(s) } if else_statements
      push_instruction("label #{label2}")
    end

    def c_return_statement(ast)
      is_empty_return = ast[:values].length == 2
      push_instruction 'push constant 0' if is_empty_return
      push_instruction 'return'
    end

    def c_do_statement(ast)
      subroutine_ast = child_by_name(ast, 'subroutineCall')
      c_subroutine_call(subroutine_ast)
      push_instruction 'pop temp 0'
    end

    def c_subroutine_call(ast)
      address = %w[expressionList]
      expression_list_ast = drill_by_names(ast, address)

      address = %w[className identifier identifier]
      class_name = drill_by_names(ast, address)[:value]

      address = %w[subroutineName identifier identifier]
      subroutine_name = drill_by_names(ast, address)[:value]

      full_name = [class_name, subroutine_name].join('.')

      c_expression_list(expression_list_ast)
      expressions_count = expression_list_ast[:values].count { |x| x[:value] != ',' }
      argument_count = expressions_count
      push_instruction "call #{full_name} #{argument_count}"
    end

    def c_let_statement(ast) # TODO: argument variables
      # pp '******'
      # pp ast

      values = ast[:values]
      expression = values[3]
      c_expression(expression)
      symbol = values[1][:values][0][:values][0][:value]
      push_instruction "pop #{c_symbol(symbol)}"
    end

    def c_expression_list(ast)
      # pp '******'
      # pp ast

      ast[:values].each do |exp|
        next if exp[:value] == ','

        c_expression(exp)
      end
    end

    def c_expression(ast)
      # pp '-----------'
      # pp ast
      # pp '-----------'

      compare_simple_value = lambda do |exps, type|
        exp_n = exps.length
        exp_n == 1 &&
          exps[0][:values].length == 1 &&
          exps[0][:values][0][:name] == type
      end

      sub_exps = ast[:values]

      exp_n = sub_exps.length
      is_unary = exp_n == 1 &&
                 sub_exps[0][:values].length == 2 &&
                 sub_exps[0][:values][0][:name] == 'unaryOp'
      is_group = exp_n == 1 &&
                 sub_exps[0][:values].length == 3 &&
                 sub_exps[0][:values][0][:value] == '('
      is_number = compare_simple_value.call(sub_exps, 'integerConstant')
      is_keyword_const = compare_simple_value.call(sub_exps, 'keywordConstant')
      is_subroutine_call = compare_simple_value.call(sub_exps, 'subroutineCall')
      is_var = exp_n == 1 &&
               sub_exps[0][:values].length == 1 &&
               sub_exps[0][:values][0][:name] == 'varName'
      is_combo = exp_n >= 3 &&
                 sub_exps[1][:name] == 'op'

      if is_number
        number = sub_exps[0][:values][0][:values][0][:value]
        push_instruction "push constant #{number}"
      elsif is_keyword_const
        keyword_const = drill_by_names(ast, %w[term keywordConstant keyword])[:value]
        value = { 'true' => '32767', 'false' => '0' }[keyword_const] || keyword_const
        push_instruction "push constant #{value}"
      elsif is_var
        var = sub_exps[0][:values][0][:values][0][:values][0][:value]
        push_instruction "push #{c_symbol(var)}" # scar de symboltable
      elsif is_group
        new_exps = sub_exps[0][:values][1]
        c_expression(new_exps)
      elsif is_subroutine_call
        address = %w[term subroutineCall]
        subroutine_call_ast = drill_by_names(ast, address)
        c_subroutine_call(subroutine_call_ast)
      elsif is_unary
        op = sub_exps[0][:values][0][:values][0][:value]
        term = sub_exps[0][:values][1]
        c_expression({ values: [term] })
        push_instruction map_operator(op, unary: true)
      elsif is_combo
        op = sub_exps[1][:values][0][:value]

        c_expression({ values: [sub_exps[0]] })
        c_expression({ values: sub_exps[2..] })
        push_instruction map_operator(op)
      end
    end

    def c_symbol(symbol)
      symbol_data = subroutine_table[symbol] || class_table[symbol]
      "#{symbol_data[:kind]} #{symbol_data[:index]}"
    end

    def map_operator(op, unary: false)
      return { '-' => 'neg', '~' => 'not' }[op] if unary

      { '-' => 'sub',
        '+' => 'add',
        '*' => 'call Math.multiply 2',
        '=' => 'eq',
        '>' => 'gt',
        '<' => 'lt',
        '&' => 'and',
        '|' => 'or' }[op]
    end

    def c_parameter_list(ast)
      return if ast.nil?

      types = children_by_name(ast, 'type').map do |vn|
        vn[:values][0][:value]
      end
      names = children_by_name(ast, 'varName').map do |vn|
        drill_by_names(vn, %w[identifier identifier])[:value]
      end

      names.each_with_index do |name, index|
        type = types[index]
        subroutine_table.define(name: name, type: type, kind: 'argument')
      end
    end

    def c_subroutine_var_dec(ast)
      c_var_dec(subroutine_table, ast)
    end

    def c_class_var_dec(ast)
      c_var_dec(class_table, ast)
    end

    def c_var_dec(table, ast)
      kind = ast[:values][0][:value]
      kind = 'local' if kind == 'var'
      type = ast[:values][1][:values][0][:value]
      children_by_name(ast, 'varName').map do |vn|
        name = drill_by_names(vn, %w[identifier identifier])[:value]
        table.define(name: name, type: type, kind: kind)
      end
    end

    def unique_label(prefix)
      @unique_ids ||= {}
      @unique_ids[prefix] = @unique_ids[prefix] ? @unique_ids[prefix] + 1 : 0
      "#{prefix}-#{@unique_ids[prefix]}"
    end

    def push_instruction(inst)
      state[:instructions] << inst
    end

    def children_by_name(ast, name)
      ast[:values].select { |v| v[:name] == name }
    end

    def child_by_name(ast, name)
      ast[:values].find { |v| v[:name] == name }
    end

    def drill_by_names(ast, names)
      current = ast
      names.each do |n|
        current = child_by_name(current, n)
      end
      current
    end
  end
end
