module Jack
  class PreProcessor
    attr_accessor :file

    def initialize(file)
      @file = file
      @inside_comment = false
    end

    def process
      file.foreach do |line|
        new_line = clear_line(line)
        process_line(new_line)
      end
    end

    private

    def process_line
      new_line = process_inline_comment(line)


      # line.split.map do  |word|
      #   process_word(word)
      # end.compact.join(" ")
    end

    def process_inline_comment(line)
      line.split("//")[0]
      # return line if line.start_with("//")
    end

    def process_block_comment(line)

    end

    def clear_line
      line.split(" ").join(" ")
    end


    # def process_word(word)
    #   if inside_comment
    #     process_comment(word)
    #   else
    #     process_code(word)
    #   end




    # end

    # def process_comment(word)
    #   # if word.start_with?("/**")
    #   #   @inside_comment = true
    #   #   return
    #   # elsif word.end_with?("/**")

    #   if word.include?("*/")
    #     @inside_comment = false
    #     word.split("*/")[1]
    #   end

    # end




    # def clean_line(str)
    #   str.split('//').first.split(' ')
    # end
  end
end




