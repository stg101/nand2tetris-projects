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

      @state = {
        classname: '',
        instructions: []
      }
    end

    def compile
      # produce_bundle = internal_paths.length > 1
      produce_bundle = false
      clear_file(bundle_path) if produce_bundle

      internal_paths.each do |path|
        file = File.open(path)
        vm_path = path.delete_suffix('.jack').concat('.vm')
        vm_code = compile_file(file).join("\n").concat("\n")
        File.open(vm_path, 'w') { |f| f.write vm_code }
        File.open(bundle_path, 'a') { |f| f.write vm_code } if produce_bundle
      end
    end

    private

    def clear_file(path)
      File.open(path, 'w') {}
    end

    def bundle_path
      main_path = internal_paths.find { |p| p.include? 'Main.jack' }
      main_path.delete_suffix('Main.jack').concat('bundle.vm')
    end

    def parse_internal_paths(path)
      return [path] unless File.directory?(path)

      Dir
        .glob("#{path}/*")
        .select { |e| File.file?(e) && e.end_with?('.jack') }
    end

    def compile_file(file)
      state[:instructions] = []
      class_table.refresh
      subroutine_table.refresh
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
      # pp ast
      subroutine_table.refresh
      type = child_by_name(ast, 'keyword')[:value]
      name = drill_by_names(ast, %w[subroutineName identifier identifier])[:value]
      classname = state[:classname]

      body_ast = child_by_name(ast, 'subroutineBody')
      params_ast = child_by_name(ast, 'parameterList')
      var_decs = children_by_name(body_ast, 'varDec')

      start_pos = state[:instructions].length # hacky can be improved

      if type == 'constructor'
        n_fields = class_table.count_by_kind('field')
        alloc(n_fields)
        push_instruction('pop pointer 0')
      elsif type == 'method'
        subroutine_table.define(name: 'this', type: classname, kind: 'argument')
        push_instruction('push argument 0')
        push_instruction('pop pointer 0')
      end

      c_parameter_list(params_ast)

      var_decs.each do |dec|
        c_subroutine_var_dec(dec)
      end

      local_vars_count = subroutine_table.count_by_kind('local')
      local_vars_count += 1 if type == 'method'

      inst = "function #{classname}.#{name} #{local_vars_count}"
      state[:instructions].insert(start_pos, inst)

      statements = child_by_name(body_ast, 'statements')[:values]
      statements.each do |s|
        c_statement(s)
      end
    end

    def alloc(n_words)
      push_instruction("push constant #{n_words}")
      push_instruction('call Memory.alloc 1')
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
      label1 = unique_label('L1while')
      label2 = unique_label('L2while')

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
      label1 = unique_label('L1if')
      label2 = unique_label('L2if')

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
      if is_empty_return
        push_instruction 'push constant 0'
      else
        c_expression child_by_name(ast, 'expression')
      end
      push_instruction 'return'
    end

    def c_do_statement(ast)
      subroutine_ast = child_by_name(ast, 'subroutineCall')
      c_subroutine_call(subroutine_ast)
      push_instruction 'pop temp 0'
    end

    # TODO : finish method dec implementation

    def c_subroutine_call(ast) # TODO: handle object operations
      address = %w[expressionList]
      expression_list_ast = drill_by_names(ast, address)

      address = %w[className identifier identifier]
      class_name = drill_by_names(ast, address)&.[](:value)

      address = %w[subroutineName identifier identifier]
      subroutine_name = drill_by_names(ast, address)&.[](:value)

      full_name = [class_name, subroutine_name].compact.join('.')
      argument_count = 0
      if class_name.nil?
        class_name = state[:classname]
        full_name = [class_name, subroutine_name].join('.')
        argument_count += 1
        push_instruction 'push pointer 0'
      elsif (object = find_in_tables(class_name))
        full_name = [object[:type], subroutine_name].compact.join('.')
        argument_count += 1
        push_instruction "push #{c_symbol(class_name)}"
      end

      unless expression_list_ast.nil?
        c_expression_list(expression_list_ast)
        argument_count += expression_list_ast[:values].count { |x| x[:value] != ',' }
      end

      push_instruction "call #{full_name} #{argument_count}"
    end

    def find_in_tables(symbol)
      subroutine_table[symbol] || class_table[symbol]
    end

    def c_let_statement(ast) # TODO: argument variables
      # pp '******'
      # pp ast

      is_array_assignment = ast[:values][2][:value] == '[' && ast[:values][4][:value] == ']'
      return c_array_assignment(ast) if is_array_assignment

      c_simple_assignment(ast)
    end

    def c_array_assignment(ast)
      symbol = drill_by_names(ast, %w[varName identifier identifier])[:value]
      index_expression = ast[:values][3]
      value_expression = ast[:values][6]
      push_instruction "push #{c_symbol(symbol)}"
      c_expression index_expression
      push_instruction 'add'
      c_expression value_expression
      push_instruction 'pop temp 0'
      push_instruction 'pop pointer 1'
      push_instruction 'push temp 0'
      push_instruction 'pop that 0'
    end

    def c_simple_assignment(ast)
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

    # TODO: add array access expresion
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
      is_string = compare_simple_value.call(sub_exps, 'stringConstant')
      is_var = exp_n == 1 &&
               sub_exps[0][:values].length == 1 &&
               sub_exps[0][:values][0][:name] == 'varName'
      is_array_access = exp_n == 1 &&
                        sub_exps[0][:values].length == 4 &&
                        sub_exps[0][:values][0][:name] == 'varName' &&
                        sub_exps[0][:values][1][:value] == '[' &&
                        sub_exps[0][:values][3][:value] == ']'

      is_combo = exp_n >= 3 &&
                 sub_exps[1][:name] == 'op'

      if is_number
        number = sub_exps[0][:values][0][:values][0][:value]
        push_instruction "push constant #{number}"
      elsif is_keyword_const
        keyword_const = drill_by_names(ast, %w[term keywordConstant keyword])[:value]

        case keyword_const
        when 'true'
          push_instruction 'push constant 1'
          push_instruction 'neg'
        when 'false', 'null'
          push_instruction 'push constant 0'
        when 'this'
          push_instruction 'push pointer 0'
        else
          push_instruction "push constant #{keyword_const}"
        end
      elsif is_string
        str = drill_by_names(ast, %w[term stringConstant stringConstant])[:value]
        chars = str.split('').map(&:ord)
        push_instruction("push constant #{chars.length}")
        push_instruction('call String.new 1')

        chars.each do |c|
          push_instruction("push constant #{c}")
          push_instruction('call String.appendChar 2')
        end

        # push size
        # call String.new 1
        # push 56 #A
        # call String.appendChar 2
        # push 57 #B
        # call String.appendChar 2
      elsif is_array_access
        symbol = drill_by_names(ast, %w[term varName identifier identifier])[:value]
        expression = drill_by_names(ast, %w[term expression])
        push_instruction "push #{c_symbol(symbol)}"
        c_expression(expression)
        push_instruction 'add'
        push_instruction 'pop pointer 1'
        push_instruction 'push that 0'
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
      symbol_data = find_in_tables(symbol)
      kind = symbol_data[:kind] == 'field' ? 'this' : symbol_data[:kind]
      "#{kind} #{symbol_data[:index]}"
    end

    def map_operator(op, unary: false)
      return { '-' => 'neg', '~' => 'not' }[op] if unary

      { '-' => 'sub',
        '+' => 'add',
        '*' => 'call Math.multiply 2',
        '/' => 'call Math.divide 2',
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
      address = %w[type className identifier identifier]
      class_name = drill_by_names(ast, address)&.[](:value)

      type = ast[:values][1][:values][0][:value] || class_name
      children_by_name(ast, 'varName').map do |vn|
        name = drill_by_names(vn, %w[identifier identifier])[:value]
        table.define(name: name, type: type, kind: kind)
      end
    end

    def unique_label(prefix)
      @unique_ids ||= {}
      @unique_ids[prefix] = @unique_ids[prefix] ? @unique_ids[prefix] + 1 : 0
      "#{prefix}#{@unique_ids[prefix]}"
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
        next if current.nil?

        current = child_by_name(current, n)
      end
      current
    end
  end
end
