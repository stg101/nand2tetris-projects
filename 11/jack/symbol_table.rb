module Jack
  class SymbolTable < Hash
    attr_accessor :index_table

    def initialize
      @index_table = {}
    end

    def define(name:, type:, kind:)
      current_index = index_table[kind] || 0
      self[name] = { name: name, type: type, kind: kind, index: current_index }
      index_table[kind] = current_index + 1
    end

    def count_by_kind(kind)
      values.select { |var| var[:kind] == kind }.length
    end

    def refresh
      clear
      index_table.clear
    end
  end
end
