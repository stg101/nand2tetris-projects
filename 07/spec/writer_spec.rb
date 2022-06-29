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
      expected_output = ['// add', '@SP', 'M=M-1', 'A=M', 'D=M', '@SP', 'M=M-1', 'A=M', 'M=D+M', '@SP',
                         'M=M+1']

      expect(instance.process(%w[add])).to eq(expected_output)
    end

    it 'process eq correctly' do
      expected_output = ['// eq', '@SP', 'M=M-1', 'A=M', 'D=M', '@SP', 'M=M-1', 'A=M', 'D=M-D', '@EQ_TRUE.0', 'D;JEQ',
                         '@SP', 'M=0', '(EQ_TRUE.0)', '@SP', 'M=-1', '@SP', 'M=M+1', '// eq', '@SP', 'M=M-1', 'A=M',
                         'D=M', '@SP', 'M=M-1', 'A=M', 'D=M-D', '@EQ_TRUE.1', 'D;JEQ', '@SP', 'M=0', '(EQ_TRUE.1)', '@SP', 'M=-1', '@SP', 'M=M+1'] # TODO: write these as files

      instance.process(%w[eq])
      expect(instance.process(%w[eq])).to eq(expected_output)
    end
  end
end
