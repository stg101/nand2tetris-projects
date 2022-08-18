require_relative 'tokenizer'

module Jack
  class Parser
    attr_accessor :tokenizer

    def initialize(file)
      @tokenizer = Tokenizer.new(file)
    end

    def parse
      parse_class
    end

    private


    def eat(token_name, token_value = nil)
      token = tokenizer.advance
      return false if token[:name] != token_name
      return false if !token_value.nil? && token[:value] != token_value

      name = camelize(token[:name])
      "<#{name}> #{token[:value]} </#{name}>"
    end

    def parse_pattern(pattern)
      op = instr[0]
  
      send("#{op}_template")
    end

    def parse_class
      wrap('class') do
        [eat('keyword', 'class'),
         eat('identifier'),
         eat('symbol', '{'),
         parse_class_var_dec]
      end
    end

    def parse_class_var_dec
      wrap('classVarDec') do
        [
          eat('keyword', 'static') || eat('keyword', 'field'),
          eat('keyword', 'type'),
          eat('indentifier')
        ]
      end
    end

    def pattern_or(patterns)

    end

    def wrap(tag)
      "<#{tag}>\n#{yield.join("\n")}\n<#{tag}>"
    end

    def camelize(str)
      words = str.split('_')
      words[0] + words[1..].collect(&:capitalize).join
    end

    def parse_expr_list(expr_list)
      grab_token!

      expr_list.any do |expr|

      end
    end

    # def validate_expr(expr)
    #   subexpr_list = parse_subexpr(expr)

    #   subexpr_list.any do |subexpr|
    #     validate_expr(subexpr)
    #   end
    # end

    # def validate_expr(expr)
    #   expr.any do |expr_item|
    #     grab_token!
    #     validate_expr(expr_item)
    #   end
    # end

    def validate_expr(expr)
      grab_token!
      
      if terminal
        expr == last_token
      else
        expr.any do |expr_item|
          validate_expr(expr_item)
        end
      end
    end

    def grab_token
      state[:token] = file.advance
      state[:buffer] << state[:token]
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
