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
      internal_paths.map do |path|
        file = File.open(path)
        compile_file(file)
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

    def c_subroutine_dec(ast)
      subroutine_table.refresh
      name = ast[:values][0][:value]
      classname = state[:classname]

      body_ast = child_by_name(ast, 'subroutineBody')
      var_decs = children_by_name(body_ast, 'varDec')
      inst = "function #{classname}.#{name} #{var_decs.length}"
      state[:instructions] << inst

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
      end
    end

    def c_let_statement(ast)
      values = ast[:values]
      symbol = values[1][:values][0][:values][0][:value]
      expression = values[3]
      c_expression(expression)
    end

    def c_expression(ast)
      # pp '-----------'
      # pp ast
      # pp '-----------'

      sub_exps = ast[:values]

      exp_n = sub_exps.length
      is_unary = exp_n == 1 &&
                 sub_exps[0][:values].length == 2 &&
                 sub_exps[0][:values][0][:name] == 'unaryOp'
      is_group = exp_n == 1 &&
                 sub_exps[0][:values].length == 3 &&
                 sub_exps[0][:values][0][:value] == '('
      is_number = exp_n == 1 &&
                  sub_exps[0][:values].length == 1 &&
                  sub_exps[0][:values][0][:name] == 'integerConstant'
      is_var = exp_n == 1 &&
               sub_exps[0][:values].length == 1 &&
               sub_exps[0][:values][0][:name] == 'varName'
      is_combo = exp_n >= 3 &&
                 sub_exps[1][:name] == 'op'

      if is_number
        number = sub_exps[0][:values][0][:values][0][:value]
        state[:instructions] << "push #{number}"
      elsif is_var
        var = sub_exps[0][:values][0][:values][0][:values][0][:value]
        state[:instructions] << "push #{var}" # scar de symboltable
      elsif is_group
        new_exps = sub_exps[0][:values][1]
        c_expression(new_exps)
      elsif is_unary
        op = sub_exps[0][:values][0][:values][0][:value]
        term = sub_exps[0][:values][1]
        c_expression({ values: [term] })
        newOp = { '-' => 'neg', '~' => 'not' }[op]

        state[:instructions] << newOp
      elsif is_combo
        op = sub_exps[1][:values][0][:value]

        c_expression({ values: [sub_exps[0]] })
        c_expression({ values: sub_exps[2..] })
        state[:instructions] << op
      end
    end

    def c_subroutine_var_dec(ast)
      name, type, kind = c_var_dec(ast).values
      subroutine_table.define(name: name, type: type, kind: kind)
    end

    def c_class_var_dec(ast)
      name, type, kind = c_var_dec(ast).values
      class_table.define(name: name, type: type, kind: kind)
    end

    def c_var_dec(ast)
      kind = ast[:values][0][:value]
      type = ast[:values][1][:values][0][:value]
      name = ast[:values][2][:values][0][:values][0][:value]

      { name: name, type: type, kind: kind }
    end

    def children_by_name(ast, name)
      ast[:values].select { |v| v[:name] == name }
    end

    def child_by_name(ast, name)
      ast[:values].find { |v| v[:name] == name }
    end
  end
end
