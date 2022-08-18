module Jack
  class Grammar
    def initialize(file)
    end

    # def tokenize(str)
    #   tokens = str.split(' ')
    #   tokens.map do |token|
    #     if token[0] == "'" && token[-1] == "'"
    #       {name: 'const', value: token[1..]}
    #     elsif token == "("
    #       {name: 'group_start', value: "("}
    #     elsif token == ")"
    #       {name: 'group_start', value: ")"}
    #     end
    #   end
    # end

    def parse_pattern(str)
      chars = str.split('')
      char = ''
      index_path = []
      current_index = 0
      pattern_tree = {}
      buffer = ''
      state = 'none'

      char_index = -1

      # def grab_char
      #   char_index +=1
      #   chars[char_index]
      # end

      # def finished?
      #   char_index == chars.length && state == 'none'
      # end

      grab_char = -> do
        char_index += 1
        char = chars[char_index] || ' '
        buffer += char
      end

      while !(char_index == chars.length && state == 'none') do
        # char = grab_char
        # buffer += char
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
            state = 'metadata'
          elsif ['*', '?'].include? char
            state = 'modifier'
          elsif char == '('
            state = 'group_start'
          elsif char == ')'
            state = 'group_end'
          end
        when 'modifier'
          meta = metadata(pattern_tree, [*index_path, current_index])
          meta.merge!({modifier: char})
          buffer = ''
          state = 'none'
        when 'metadata'
          meta = metadata(pattern_tree, index_path)
          meta.merge!({type: 'or'}) if char == '|'
          buffer = ''
          state = 'none'
        when 'token'
          grab_char.call

          if char == "'"
            state = 'none'
            token = { type: 'token', value: buffer }
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
          buffer = ''
          state = 'none'
        end

        # case char
        # when "'"
        #   state = 'token'
        # else

        # end
      end

      pattern_tree
    end

    def tree_insert!(tree, path, value)
      tree[:patterns] = [] if tree[:patterns].nil?
      context = tree[:patterns]

      puts({act:"insert", path: path})
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

  # path = [0, patterns, 0]
end
