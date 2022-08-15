require 'yaml'

module Jack
  class Tokenizer
    attr_accessor :file, :state

    SYMBOLS = ['{', '}', '(', ')', '[', ']', '.', ',', ';', '+', '-', '*', '&', '|', '<', '>', '=', '~', '/'].freeze

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
        elsif ["\n", "\r", ' '].include?(state[:char])
          init_state!
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
      return init_state! if file.eof?

      state[:char] = file.readchar
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
