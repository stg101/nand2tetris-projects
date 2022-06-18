class SymbolTable
  attr_reader :table

  INITIAL_SYMBOLS = {
    SP: 0,
    LCL: 1,
    ARG: 2,
    THIS: 3,
    THAT: 4,
    SCREEN: 16_384,
    KBD: 24_576,
    R0: 0,
    R1: 1,
    R2: 2,
    R3: 3,
    R4: 4,
    R5: 5,
    R6: 6,
    R7: 7,
    R8: 8,
    R9: 9,
    R10: 10,
    R11: 11,
    R12: 12,
    R13: 13,
    R14: 14,
    R15: 15
  }.freeze

  def initialize
    @table = INITIAL_SYMBOLS.dup
    @next_internal_value = 16
  end

  def key?(key)
    table.key?(key)
  end

  def add_pair(key, value)
    table[key] = value
    table
  end

  def add_key(key)
    table[key] = next_internal_value
    @next_internal_value += 1
    table
  end

  private

  attr_accessor :next_internal_value
end
