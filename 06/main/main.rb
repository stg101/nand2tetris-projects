# Parser  unpacks instructions in to fields
# Code    translates fields to binary (translate fields) (translate field)
# SymbolTable maintains symbol values
# Main    orchestrator

# Parser; retorna el symbol table, retorna una lista de instrucciones, separadas en fields, con un tipo
# Code: reocorre las instruccionesy  los transforma a binarion, retorna el codigo en binario

# D=D+A => D D+A => 2123123 12312424

require_relative 'assembler'

path = ARGV.first

puts Assembler.new(path).assemble
