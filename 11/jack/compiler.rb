module Jack
  class Compiler
    attr_accessor :file

    def initialize(path)
      @file = File.open(path)
      @analizer = Analizer.new(file)
    
    end
  end
end