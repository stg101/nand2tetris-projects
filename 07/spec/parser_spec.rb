require './parser'

def open_file(relative_path)
  File.open("./spec/support/#{relative_path}")
end

describe Parser do
  let(:file) { open_file('parser_test.vm') }
  let(:instance) { described_class.new(file) }

  it 'initializes correctly' do
    expected_content = [
      %w[push constant 111],
      %w[pop static 8],
      %w[push static 1],
      ['sub'],
      %w[push static 8],
      ['add']
    ]

    expect(instance.content).to eq(expected_content)
  end

  describe '#finished?' do
    it 'returns true when finished' do
      size = instance.content.length
      size.times { instance.parse_next }

      expect(instance.finished?).to eq(true)
    end

    it 'returns false when is not finished' do
      size = instance.content.length
      (size - 1).times { instance.parse_next }

      expect(instance.finished?).to eq(false)
    end
  end

  describe '#parse_next' do
    it 'returns the next instruction' do
      expect(instance.parse_next).to eq(%w[push constant 111])
      expect(instance.parse_next).to eq(%w[pop static 8])
    end
  end
end
