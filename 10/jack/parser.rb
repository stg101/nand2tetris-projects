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
        buffer_index: 0,
        token: nil,
        error: ''
      }
    end

    def parse
      # parse_label("subroutineName")
    end

    # private
    def parse_pattern(pattern)
      type = pattern[:type] || 'group'

      # puts pattern

      case type
      when 'token'
        parse_token(pattern)
      when 'nonterm'
        parse_label(pattern[:value])
      when 'group'
        parse_group(pattern)
      end
    end

    def parse_label(name)
      pattern = find_pattern(name)
      parse_pattern(pattern)
    end

    def parse_group(pattern)
      result = []

      pattern[:patterns].each do |p|
        reset_buffer_index!
        result_item = parse_pattern(p)
        raise "failed pattern : #{pattern}" unless result_item

        result << result_item
        clear_buffer!
      end

      result.join("\n")
    end

    def parse_token(pattern)
      reset_buffer_index!
      grab_token!

      if pattern[:name].nil? && !pattern[:value].nil?
        pattern[:name] = find_token_def(pattern[:value])[:name]
        match_name = pattern[:name] == current_token[:name]
        match_value = pattern[:value] == current_token[:value]

        return false unless match_name && match_value
      elsif !pattern[:name].nil? && pattern[:value].nil?
        match_name = pattern[:name] == current_token[:name]

        return false unless match_name
      end

      clear_buffer!
      build_token_element(current_token)
    end

    def build_token_element(token)
      tag = token[:name]
      "<#{tag}> #{token[:value]} </#{tag}>"
    end

    def set_error!(error)
      state[:error] = error
    end

    def clear_buffer!
      state[:buffer] = []
    end

    def current_token
      state[:token]
    end

    def find_token_def(value)
      grammar.find do |p|
        p[:type] == 'token' && p[:match_value].include?(value)
      end
    end

    def reset_buffer_index!
      state[:buffer_index] = 0
    end

    def grab_token!
      if state[:buffer].length == state[:buffer_index]
        state[:token] = tokenizer.advance
        state[:buffer] << state[:token]
      else
        index = state[:buffer_index]
        state[:token] = state[:buffer][index]
      end

      state[:buffer_index] += 1
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
