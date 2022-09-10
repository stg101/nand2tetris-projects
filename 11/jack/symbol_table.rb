module Jack
  class SymbolTable < Hash
    # attr_accessor :table

    def initialize
      # @table = {}
    end

    def define(name:, type:, kind:)
      self[name] = { name: name, type: type, kind: kind }
    end

    def refresh
      clear
    end
  end
end
