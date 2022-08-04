module Jack
  class Analizer
    def initialize(file)
      @tokenizer = Tokenizer.new(file)
    end
  end
end
