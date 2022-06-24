require './writer'

describe Writer do
  let(:instance) { described_class.new('asd') }

  it 'initializes correctly' do
    instance
  end

  describe '#process' do
    it 'process push constant c correctly' do
      expected_output = ['// push constant 5', '@5', 'D=A', '@SP', 'A=M', 'M=D', '@SP', 'M=M+1']

      expect(instance.process(%w[push constant 5])).to eq(expected_output)
    end

    it 'process add correctly' do
      expected_output = ['// add', '@SP', 'M=M-1', 'A=M', 'D=M', '@SP', 'M=M-1', 'M=M-1', 'A=M', 'M=D+M', '@SP',
                         'M=M+1']

      expect(instance.process(%w[add])).to eq(expected_output)
    end
  end
end
