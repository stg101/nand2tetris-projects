require_relative 'tokenizer'
require_relative 'grammar'

module Jack
  class Parser
    attr_accessor :tokenizer, :grammar, :state

    def initialize(file, grammar_file)
      @tokenizer = Tokenizer.new(file)
      @grammar = Grammar.new(grammar_file).parse

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

      state[:token] = new_token
      state[:buffer_index] = new_index
    end

    def decrement_index
      new_index = state[:buffer_index] - 1
      # return if new_index.negative?

      new_token = state[:buffer][new_index]
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
    end

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
          parse_label(pattern[:value])
        when 'group'
          parse_group(pattern)
        when 'or'
          parse_or(pattern)
        end

      # clear_result(result)
      rr = clear_result(result)

      # p rr

      # p 'tkn: '
      # p current_token
      # p '>>>>>>>>>>>' * 5
      rr
    end

    def clear_result(result)
      if result.is_a? Array
        result.reject { |r_item| r_item == 'ignore' }
      else
        result
      end
    end

    def parse_label(name)
      # puts "[ #{name} ]"
      pattern = find_pattern(name)
      parse_pattern(pattern)
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

      current_token
    end

    def build_token_element(token)
      tag = token[:name]
      "<#{tag}> #{token[:value]} </#{tag}>"
    end

    def set_error!(error)
      state[:error] = error
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
