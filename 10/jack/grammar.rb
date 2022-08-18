require 'yaml'

module Jack
  class Grammar
    attr_accessor :original, :rules

    def initialize(file)
      @original = YAML.load_file(file, symbolize_names: true)
      @rules = []
    end

    def parse
      original[:grammar].map do |k,v|
        parse_pattern(v).merge({name: k})
      end
    end

    def parse_pattern(str)
      chars = str.split('')
      char = ''
      index_path = []
      current_index = 0
      pattern_tree = {}
      buffer = ''
      state = 'none'

      char_index = -1

      grab_char = -> do
        char_index += 1
        char = chars[char_index] || ' '
        buffer += char
      end

      while !(char_index == chars.length && state == 'none') do
        # puts({ char: char, state: state, buffer: buffer})
        # puts pattern_tree

        case state
        when 'none'
          grab_char.call
          state = 'processing'
        when 'processing'
          if char == "'"
            state = 'token'
          elsif char == ' '
            buffer = ''
            state = 'none'
          elsif char == '|'
            state = 'or'
          elsif ['*', '?'].include? char
            state = 'modifier'
          elsif ['(', '['].include? char
            state = 'group_start'
          elsif [')', ']'].include? char
            state = 'group_end'
          elsif char.match('^[a-zA-Z0-9_]*$')
            state = 'non_term'
          end
        when 'non_term'
          grab_char.call

          if !char.match('^[a-zA-Z0-9_]*$')
            nonterm = { type: 'nonterm', value: buffer[0..-2] }
            tree_insert!(pattern_tree, index_path, nonterm)
            current_index += 1
            buffer = char
            state = 'processing'
          end
        when 'modifier'
          meta = metadata(pattern_tree, [*index_path, current_index - 1])
          meta.merge!({modifier: char})
          buffer = ''
          state = 'none'
        when 'or'
          meta = metadata(pattern_tree, index_path)
          meta.merge!({type: 'or'})

          # patterns = meta[:patterns].dup
          # sub_group = patterns.filter {|p| p[:type] != 'implicit_group'}
          # old_groups = patterns.filter {|p| p[:type] == 'implicit_group'}

          # if !sub_group.empty?
          #   meta[:patterns] = old_groups
          #   meta[:patterns] << {
          #     type: 'implicit_group',
          #     patterns: sub_group
          #   }
          # end

          buffer = ''
          state = 'none'
        when 'token'
          grab_char.call

          if char == "'"
            token = { type: 'token', value: buffer[1..-2] || '' }
            tree_insert!(pattern_tree, index_path, token)
            current_index += 1
            buffer = ''
            state = 'none'
          end
        when 'group_start'
          index_path << current_index
          current_index = 0
          buffer = ''
          state = 'none'
        when 'group_end'
          current_index = index_path.pop
          current_index += 1
          buffer = ''
          state = 'none'
        end
      end

      pattern_tree
    end

    def tree_insert!(tree, path, value)
      tree[:patterns] = [] if tree[:patterns].nil?
      context = tree[:patterns]

      # puts({act:"insert", path: path})
      path.each do |key|
        context[key] = {} if context[key].nil?
        context[key][:patterns] = [] if context[key][:patterns].nil?
        context = context[key][:patterns]
      end

      context << value
    end

    def metadata(tree, path)
      context = tree

      path.each do |key|
        context = context[:patterns][key]
      end

      context
    end
  end
end


# create a new type implicit group
# ors (|) create implicit groups
