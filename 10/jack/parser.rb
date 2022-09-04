require_relative 'tokenizer'
require_relative 'grammar'

module Jack
  class Parser
    attr_accessor :tokenizer, :grammar, :state, :global_result, :label_pointers, :instructions

    def initialize(file, grammar_file)
      @tokenizer = Tokenizer.new(file)
      @grammar = Grammar.new(grammar_file).parse
      @global_result = {}
      @label_pointers = []
      @instructions = []
      @random_seed = 0

      # pp grammar

      @state = {
        buffer: [],
        buffer_index: -1,
        token: nil,
        error: ''
      }
    end

    #     (a | b) (c | d)
    #     (a b) | (c d)

    # inside an or group we go back
    # to initial state every step

    # inside normal group we dont
    # go back,
    # set_
    # hide buffer abstraction
    # inside index abstraction

    def increment_index
      new_index = state[:buffer_index] + 1
      new_token = state[:buffer][new_index]
      if new_token.nil?
        new_token = tokenizer.advance
        state[:buffer] << new_token
      end

      @instructions << { address: @label_pointers.dup, value: new_token }
      state[:token] = new_token
      state[:buffer_index] = new_index
    end

    def decrement_index
      new_index = state[:buffer_index] - 1
      # return if new_index.negative?

      new_token = state[:buffer][new_index]

      @instructions.pop
      state[:token] = new_token
      state[:buffer_index] = new_index
    end

    def goto_index(new_index)
      while new_index != state[:buffer_index]
        if new_index < state[:buffer_index]
          decrement_index
        else
          increment_index
        end
      end
    end

    def parse
      # parse_label("subroutineName")
      # build_global_result(parse_label('class'))

      parse_label('class')
      build_global_result(@instructions)
    end

    def to_xml(values_list = 'initial', indent_places = 0)
      # pp values_list
      # skip_names = %w[class classVarDec subroutineDec parameterList subroutineBody varDec
      #                 statements letStatement ifStatement whileStatement doStatement
      #                 returnStatement expression term expressionList].freeze
      skip_names = %w[type className subroutineName varName statement 
                      subroutineCall identifier keywordConstant integerConstant 
                      stringConstant op ].freeze
      values_list = parse if values_list == 'initial'
      # return build_token_element(values_list[0]) if (values_list.length==1 && values_list[0][:values].nil?)

      result = ''
      values_list.each do |value_item|
        indentation = (' ' * 2) * indent_places
        if value_item[:values].nil?
          (result += "#{indentation}#{build_token_element(value_item)}\n")
          next
        end

        if skip_names.include?(value_item[:name])
          result +=  "#{to_xml(value_item[:values], indent_places)}\n"
          next
        end

        body = to_xml(value_item[:values], indent_places + 1)
        result += "#{indentation}<#{value_item[:name]}>\n"
        result += "#{body}\n"
        # result += to_xml(value_item[:values])
        result += "#{indentation}</#{value_item[:name]}>\n"
        # result = ident(result, 2)
      end

      result.delete_suffix("\n")
    end

    # def ident(str, places)
    #   str.split("\n").map do |chunk|
    #     " "*places + chunk
    #   end.join("\n")
    # end

    # private
    def parse_pattern(pattern)
      # p pattern
      modifier = pattern[:modifier]
      # resolve_parser(pattern)

      case modifier
      when '*'
        result = []
        r_item = true
        saved_index = state[:buffer_index]
        loop do # TODO: check what happens with the index
          saved_index = state[:buffer_index]
          r_item = resolve_parser(pattern)

          if r_item
            result << r_item
          else
            goto_index(saved_index)
            break
          end
        end

        result.empty? ? 'ignore' : result
      when '?'
        saved_index = state[:buffer_index]
        result = resolve_parser(pattern)

        if result
          result
        else
          goto_index(saved_index)
          'ignore'
        end

        # resolve_parser(pattern) || 'ignore'
      else
        resolve_parser(pattern)
      end
    end

    def resolve_parser(pattern)
      # p '<<<<<<<<<<<' * 5
      # p pattern

      type = pattern[:type] || 'group'

      result =
        case type
        when 'token'
          parse_token(pattern)
        when 'nonterm'
          abc = parse_label(pattern[:value])
          label_pointers.pop

          abc
        when 'group'
          parse_group(pattern)
        when 'or'
          parse_or(pattern)
        end

      # clear_result(result)
      clear_result(result)

      # p rr

      # p 'tkn: '
      # p current_token
      # p '>>>>>>>>>>>' * 5
    end

    def clear_result(result)
      if result.is_a? Array
        result.reject { |r_item| r_item == 'ignore' }
      else
        result
      end
    end

    def parse_label(name)
      # p label_pointers
      # puts "[ #{name} ]"
      @random_seed += 1
      label_pointers << "#{name}_L#{@random_seed}"
      pattern = find_pattern(name)
      parse_pattern(pattern)

      # global_result << {name: name, type: 'label', value: result}
    end

    def parse_or(pattern)
      initial_index = state[:buffer_index]
      result = nil

      pattern[:patterns].find do |p|
        goto_index(initial_index)
        result = parse_pattern(p)
        break if result
      end

      raise pattern_error(pattern) if result.nil?

      result
    end

    def parse_group(pattern)
      result = []

      pattern[:patterns].each do |p|
        result_item = parse_pattern(p)
        if result_item
          result << result_item
        else
          result = [false]
          break
        end
      end

      return result[0] if result.length == 1
      return false if result.any?(&:!) # simplify ?

      result
    end

    def pattern_error(pattern)
      "failed pattern : #{pattern}"
    end

    def parse_token(pattern) # dup ?
      return false unless tokenizer.more_tokens?

      increment_index

      if pattern[:name].nil? && !pattern[:value].nil?
        name = find_token_def(pattern[:value])[:name]
        match_name = name == current_token[:name]
        match_value = pattern[:value] == current_token[:value]

        return false unless match_name && match_value
      elsif !pattern[:name].nil? && pattern[:value].nil?
        match_name = pattern[:name] == current_token[:name]

        return false unless match_name
      end

      # inject_global_result(label_pointers, current_token)
      current_token
    end

    def build_token_element(token)
      tag = token[:name]
      "<#{tag}> #{token[:value]} </#{tag}>"
    end

    def set_error!(error)
      state[:error] = error
    end

    def inject_global_result(address, value)
      # sym_addrs = address.map(&:to_sym)
      # global_result.dig(sym_addrs)
      current_scope = {}

      address[0..-2].each do |add_item|
        current_scope = global_result[add_item.to_sym]
        if current_scope.nil?
          global_result[add_item.to_sym] = {}
          current_scope = global_result[add_item.to_sym]
        end
      end

      current_scope[address[-1]] = value
    end

    def build_global_result(records)
      global_values = []

      records.each do |record|
        value = record[:value]
        address = record[:address]
        current_values = global_values

        address.each do |addr_item|
          target = current_values.find { |val_i| val_i[:code] == addr_item }
          if target.nil?
            name = addr_item.split('_')[0]
            target = { name: name, code: addr_item, values: [] }
            current_values << target
          end

          current_values = target[:values]
        end

        current_values << value
      end

      global_values
    end

    # def clear_buffer!
    #   # TODO: clear from current index
    #   # TODO: or_seq ???

    #   state[:buffer] = state[:buffer][]
    # end

    def current_token
      state[:token]
    end

    def find_token_def(value)
      grammar.find do |p|
        p[:type] == 'token' && p[:match_value].include?(value)
      end
    end

    def find_pattern(name)
      grammar.find do |p|
        p[:name] == name
      end
    end

    def hash_code # TODO: improve randomicity
      (0...8).map { rand(65..90).chr }.join
    end
  end
end

# tag {name, ident}

# first we need to get tokens one by one when needed
# what weird cases we have
# token | token
# noterm '(' noterm ')' | noterm
# whats the problem here
# we start grabbing tokens but fails in the last,
# we need to reuse them for the next ones
# noterm*
# we start grabbing tokens for the first
# appear if not checking the tokens can be reused

# every expression has side effects
# build the three
# manage the current tokens
# every expression has a cicle
# split
# grab first expr
# grab one token
# check # we can do dfs or bfs
# each parse should return true or false ?
#

# {:name=>"keyword", :value=>"class"}
# {:name=>"identifier", :value=>"Main"}
# {:name=>"symbol", :value=>"{"}
# {:name=>"keyword", :value=>"static"}
# {:name=>"keyword", :value=>"boolean"}
# {:name=>"identifier", :value=>"test"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"function"}
# {:name=>"keyword", :value=>"void"}
# {:name=>"identifier", :value=>"main"}
# {:name=>"symbol", :value=>"("}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>"{"}
# {:name=>"keyword", :value=>"var"}
# {:name=>"identifier", :value=>"SquareGame"}
# {:name=>"identifier", :value=>"game"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"let"}
# {:name=>"identifier", :value=>"game"}
# {:name=>"symbol", :value=>"="}
# {:name=>"identifier", :value=>"SquareGame"}
# {:name=>"symbol", :value=>"."}
# {:name=>"identifier", :value=>"new"}
# {:name=>"symbol", :value=>"("}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"do"}
# {:name=>"identifier", :value=>"game"}
# {:name=>"symbol", :value=>"."}
# {:name=>"identifier", :value=>"run"}
# {:name=>"symbol", :value=>"("}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"do"}
# {:name=>"identifier", :value=>"game"}
# {:name=>"symbol", :value=>"."}
# {:name=>"identifier", :value=>"dispose"}
# {:name=>"symbol", :value=>"("}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"return"}
# {:name=>"symbol", :value=>";"}
# {:name=>"symbol", :value=>"}"}
# {:name=>"keyword", :value=>"function"}
# {:name=>"keyword", :value=>"void"}
# {:name=>"identifier", :value=>"more"}
# {:name=>"symbol", :value=>"("}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>"{"}
# {:name=>"keyword", :value=>"var"}
# {:name=>"keyword", :value=>"int"}
# {:name=>"identifier", :value=>"i"}
# {:name=>"symbol", :value=>","}
# {:name=>"identifier", :value=>"j"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"var"}
# {:name=>"identifier", :value=>"String"}
# {:name=>"identifier", :value=>"s"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"var"}
# {:name=>"identifier", :value=>"Array"}
# {:name=>"identifier", :value=>"a"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"if"}
# {:name=>"symbol", :value=>"("}
# {:name=>"keyword", :value=>"false"}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>"{"}
# {:name=>"keyword", :value=>"let"}
# {:name=>"identifier", :value=>"s"}
# {:name=>"symbol", :value=>"="}
# {:name=>"string_constant", :value=>"string constant"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"let"}
# {:name=>"identifier", :value=>"s"}
# {:name=>"symbol", :value=>"="}
# {:name=>"keyword", :value=>"null"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"let"}
# {:name=>"identifier", :value=>"a"}
# {:name=>"symbol", :value=>"["}
# {:name=>"integer_constant", :value=>"1"}
# {:name=>"symbol", :value=>"]"}
# {:name=>"symbol", :value=>"="}
# {:name=>"identifier", :value=>"a"}
# {:name=>"symbol", :value=>"["}
# {:name=>"integer_constant", :value=>"2"}
# {:name=>"symbol", :value=>"]"}
# {:name=>"symbol", :value=>";"}
# {:name=>"symbol", :value=>"}"}
# {:name=>"keyword", :value=>"else"}
# {:name=>"symbol", :value=>"{"}
# {:name=>"keyword", :value=>"let"}
# {:name=>"identifier", :value=>"i"}
# {:name=>"symbol", :value=>"="}
# {:name=>"identifier", :value=>"i"}
# {:name=>"symbol", :value=>"*"}
# {:name=>"symbol", :value=>"("}
# {:name=>"symbol", :value=>"-"}
# {:name=>"identifier", :value=>"j"}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"let"}
# {:name=>"identifier", :value=>"j"}
# {:name=>"symbol", :value=>"="}
# {:name=>"identifier", :value=>"j"}
# {:name=>"symbol", :value=>"/"}
# {:name=>"symbol", :value=>"("}
# {:name=>"symbol", :value=>"-"}
# {:name=>"integer_constant", :value=>"2"}
# {:name=>"symbol", :value=>")"}
# {:name=>"symbol", :value=>";"}
# {:name=>"keyword", :value=>"let"}
# {:name=>"identifier", :value=>"i"}
# {:name=>"symbol", :value=>"="}
# {:name=>"identifier", :value=>"i"}
# {:name=>"symbol", :value=>"|"}
# {:name=>"identifier", :value=>"j"}
# {:name=>"symbol", :value=>";"}
# {:name=>"symbol", :value=>"}"}
# {:name=>"keyword", :value=>"return"}
# {:name=>"symbol", :value=>";"}
# {:name=>"symbol", :value=>"}"}
# {:name=>"symbol", :value=>"}"}
# {:name=>"symbol", :value=>"}"}
