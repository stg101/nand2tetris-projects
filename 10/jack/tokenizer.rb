require 'yaml'

module Jack
  class Tokenizer
    attr_accessor :file, :state

    SYMBOLS = ['{', '}', '(', ')', '[', ']', '.', ',', ';', '+', '-', '*', '&', '|', '<', '>', '=', '~', '/'].freeze
    KEYWORDS = ['class','constructor','function','method','field','static','var','int','char','boolean','void','true','false','null','this','let','do','if','else','while','return'].freeze

    def initialize(file)
      @file = file
      @state = {
        name: 'none',
        char: '',
        buffer: '',
        token_stack: []
      }
    end

    def step
      return if finished?

      if state[:name] == 'none'
        grab_char!
        change_name! 'processing'
      elsif state[:name] == 'processing'
        if is_symbol(state[:char]) && state[:char] != '/'
          commit_token!('symbol', scape_symbol(state[:char]))
          init_state!
        elsif state[:char] == '/'
          change_name! 'slash'
        elsif state[:char] == '"'
          change_name! 'string'
        elsif is_number(state[:char])
          change_name! 'number'
        elsif is_word(state[:char])
          change_name! 'word'
        elsif state[:char].match(/\s/)
          init_state!
        end
      elsif state[:name] == 'string'
        grab_char!

        if state[:char] == '"'
          str = state[:buffer][1..-2]
          commit_token!('string_constant', str)
          init_state!
        end
      elsif state[:name] == 'number'
        grab_char!

        if !is_number(state[:buffer])
          raise "invalid identifier" if is_word(state[:char])

          number = state[:buffer][0..-2]
          commit_token!('integer_constant', number)
          state[:buffer] = state[:char]
          change_name! 'processing'
        end
      elsif state[:name] == 'word'
        grab_char!

        if !is_word(state[:buffer])
          word = state[:buffer][0..-2]

          if is_keyword(word)
            commit_token!('keyword', word)
          else
            commit_token!('identifier', word)
          end
          state[:buffer] = state[:char]
          change_name! 'processing'
        end
      elsif state[:name] == 'slash'
        grab_char!

        if state[:buffer] == '//'
          change_name! 'inline_comment'
        elsif state[:buffer] == '/*'
          change_name! 'block_comment'
        else
          commit_token!('symbol', '/')
          state[:buffer] = state[:char]
          change_name! 'processing'
        end

      elsif state[:name] == 'inline_comment'
        grab_char!

        if state[:char] == "\n" || eof?
          init_state!
        end
      elsif state[:name] == 'block_comment'
        grab_char!

        if state[:buffer].end_with?('*/') || eof?
          init_state!
        end
      end
    end

    def advance
      stack_length = token_stack.length
      step until token_stack.length > stack_length || finished?

      camelize_token(token_stack[-1])
    end

    def token_type
      return if token_stack.empty?

      token_stack[-1][:name]
    end

    def traverse
      advance until finished?
      state[:token_stack]
    end

    def is_symbol(char)
      SYMBOLS.include?(char)
    end
    
    def is_word(str)
      !str.match(/\s/) && str.match("^[a-zA-Z_][a-zA-Z0-9_]*$")
    end

    def is_number(str)
      !str.match(/\s/) && str.match("^[0-9]+$")
    end

    def is_keyword(str)
      is_word(str) && KEYWORDS.include?(str)
    end

    def change_name!(name)
      state[:name] = name
    end

    def clear_buffer!
      state[:buffer] = ''
    end

    def init_state!
      state[:name] = 'none'
      state[:buffer] = ''
    end

    def commit_token!(token, value)
      state[:token_stack] << {name: token, value: value}
      state[:buffer] = ''
    end

    def skip_char!
      state[:char] = file.readchar
    end

    def grab_char!
      state[:char] = file.eof? ? ' ' : file.readchar
      # print state[:char]
      state[:buffer] += state[:char]
    end

    def eof?
      file.eof?
    end

    def finished?
      file.eof? && (state[:name] == 'none')
    end

    def more_tokens?
      !finished?
    end

    def token_stack
      state[:token_stack]
    end

    def to_xml
      traverse

      tokens = token_stack.map do |token|
        name = camelize(token[:name])
        "<#{name}> #{token[:value]} </#{name}>"
      end

      ['<tokens>', *tokens, "</tokens>\n"].join("\n")
    end

    def camelize(str)
      words = str.split('_')
      words[0] + words[1..-1].collect(&:capitalize).join
    end

    def camelize_token(tk)
      {
        name: camelize(tk[:name]),
        value: tk[:value]
      }
    end

    def scape_symbol(char)
      if(char == "<")
        '&lt;'
      elsif (char == ">")
        '&gt;'
      elsif (char == "&")
        '&amp;'
      elsif (char == '"')
        '&quot;'
      else
        char
      end
    end
  end
end
