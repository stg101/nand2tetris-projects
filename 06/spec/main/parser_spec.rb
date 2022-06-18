require './main/parser'

def open_file(relative_path)
  File.open("./spec/support/#{relative_path}")
end

describe Parser do
  let(:file) { open_file('ParserTest.asm') }
  let(:instance) { described_class.new(file) }

  it 'initializes correctly' do
    expect(instance.table).to eq(SymbolTable::INITIAL_SYMBOLS)
  end

  describe '#parse' do
    it 'fills the symbol table correctly' do
      expected_table = SymbolTable::INITIAL_SYMBOLS.dup
      expected_table.merge!({ AAA: 8, BBB: 9, CCC: 9, DDD: 10, asdf: 16, ghjk: 17 })
      instance.parse

      expect(instance.table).to eq(expected_table)
    end

    it 'fills the instruction correctly' do
      instance.parse

      expected_instructions = [
        %w[a_instruction R1],
        %w[c_instruction D-M D JGT],
        %w[a_instruction asdf],
        ['c_instruction', '0', nil, 'JMP'],
        %w[a_instruction ghjk],
        ['c_instruction', '0', nil, 'JMP'],
        %w[a_instruction DDD],
        ['c_instruction', 'D', nil, 'JGT'],
        %w[a_instruction R2],
        %w[a_instruction R3],
        %w[a_instruction R4],
        %w[a_instruction 1000]
      ]

      expect(instance.instructions).to eq(
        expected_instructions
      )
    end
  end
end
