require './main/symbol_table'

describe SymbolTable do
  let(:instance) { described_class.new }

  it 'initilizes correctly' do
    expect(instance.table).to eq(SymbolTable::INITIAL_SYMBOLS)
  end

  describe '#add_pair' do
    it 'adds a pair correctly' do
      instance.add_pair(:KEY, 666)

      expect(instance.table[:KEY]).to eq(666)
    end
  end

  describe '#add_key' do
    it 'adds a key correctly' do
      instance.add_key(:KEY1)
      instance.add_key(:KEY2)
      instance.add_key(:KEY3)
      instance.add_key(:KEY4)

      expect(instance.table[:KEY4]).to eq(19)
    end
  end

  describe '#key?' do
    it 'returns true if key exists' do
      instance.add_key(:KEY1)

      expect(instance.key?(:KEY1)).to eq(true)
    end
  end
end
