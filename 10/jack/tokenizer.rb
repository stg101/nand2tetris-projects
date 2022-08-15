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

    def advance ## check transitions
      return if finished?

      if state[:name] == 'none'
        grab_char!
        change_name! 'processing'
      elsif state[:name] == 'processing'
        if is_symbol(state[:char]) && state[:char] != '/'
          commit_token!('symbol', state[:char])
          init_state!
        elsif state[:char] == '/'
          change_name! 'slash'
        elsif is_word(state[:char])
          change_name! 'word'
        elsif ["\n", "\r", ' '].include?(state[:char])
          init_state!
        end
      elsif state[:name] == 'word'
        grab_char!

        if !is_word(state[:buffer])
          word = state[:buffer][0..-2]

          if is_keyword(word)
            commit_token!('keyword', word)
          else
            commit_token!('indentifier', word)
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
      state[:token_stack] << {token: token, value: value}
      state[:buffer] = ''
    end

    def skip_char!
      state[:char] = file.readchar
    end

    def grab_char!
      state[:char] = file.eof? ? ' ' : file.readchar
      state[:buffer] += state[:char]
    end

    def eof?
      file.eof?
    end

    def finished?
      file.eof? && (state[:name] == 'none')
    end
  end
end
