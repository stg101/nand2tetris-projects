require 'yaml'

module Jack
  class Tokenizer
    attr_accessor :file, :current_str, :last_match, :token_stack, :grammar

    def initialize(file, grammar_file)
      @file = file
      @grammar = YAML.safe_load(grammar_file, symbolize_names: true)

      # @char_stack = []

      @current_str = ''
      @token_stack = []
      @last_match = {}

      # pp @grammar
      # @code_lines = PreProcessor.new(file)
    end

    def advance
      return if finished?

      # self.current_str += file.readchar
      current_char = file.readchar
      self.current_str += current_char
      match = match_rules(current_str)

      if !last_match[:rule].nil? && match[:rule].nil?
        token_stack << last_match
        match = match_rules(current_char)
        self.current_str = current_char
      end

      self.current_str = '' if [' ', "\n", "\r"].include?(current_char)

      self.last_match = match
    end

    def finished?
      file.eof?
    end

    def to_xml
      'asd'
    end

    private

    def match_rules(str)
      rules = grammar[:rules]

      matched_rule = rules.find do |rule|
        matcher = rule[:match]

        if matcher.is_a? Array
          matcher.include? str
        else
          !!str.match(matcher)
        end
      end

      {
        rule: (matched_rule || {})[:name],
        value: str
      }
    end
  end
end

# rule matched
# cuando cambia el rule matched a no matched o new match
# the property to expoit is that every token has specific start and end
