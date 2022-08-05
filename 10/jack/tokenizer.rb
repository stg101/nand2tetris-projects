require 'yaml'

module Jack
  class Tokenizer
    attr_accessor :file, :current_str, :last_match, :token_stack, :grammar, :state
    attr_reader :rules

    def initialize(file, grammar_file)
      @file = file
      @grammar = YAML.safe_load(grammar_file, symbolize_names: true)
      @rules = build_rules(grammar)
      @state = "keep_chars"

      @current_str = ''
      @token_stack = []
      @last_match = {}
    end

    def advance
      return if finished?

      current_char = file.readchar
      self.current_str += current_char
      match = match_rules(current_str)

      if !last_match[:rule].nil? && match[:rule].nil?
        token_stack << last_match if !last_match[:rule].include?("comment")
        match = match_rules(current_char)
        self.current_str = current_char
      end

      if ["inline_comment"].include?(match[:rule])
        self.current_str = '' if ["\n", "\r"].include?(current_char)
      elsif match[:rule] == "block_comment"
        self.current_str = ''
      elsif !["block_comment", "half_block_comment"].include?(match[:rule])
        self.current_str = '' if [" ", "\n", "\r"].include?(current_char)
      end

      self.last_match = match

      if finished? && !last_match[:rule].nil?
        token_stack << last_match
      end
    end

    def finished?
      file.eof?
    end

    def to_xml
      'asd'
    end

    private

    def build_rules(grammar)
      comment_grammar = grammar[:comments]
      inline = comment_grammar[:inline]
      block_start = Regexp.escape(comment_grammar[:block][0])
      block_end = Regexp.escape(comment_grammar[:block][1])

      comment_rules = [{
        name: 'inline_comment',
        match: "^#{inline}([^\n]*)$"
      }, {
        name: 'block_comment',
        match: "^#{block_start}((.|\n)*)#{block_end}$"
      },
      {
        name: 'half_block_comment',
        match: "^#{block_start}((.|\n)*)$"
      }
    ]

      grammar[:rules].concat(comment_rules)
    end

    def match_rules(str)
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
