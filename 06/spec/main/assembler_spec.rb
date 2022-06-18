require './main/assembler'

describe Assembler do
  let(:test_name) { 'Add' }
  let(:code_path) { build_code_path(test_name) }
  let(:expected_output) { output_file(test_name) }
  let(:instance) { described_class.new(code_path) }

  describe 'assembling the Add.asm program' do
    let(:test_name) { 'Add' }

    it 'returns the correct output' do
      expect(instance.assemble).to eq(expected_output)
    end
  end

  describe 'assembling the Max.asm program' do
    let(:test_name) { 'Max' }

    it 'returns the correct output' do
      expect(instance.assemble).to eq(expected_output)
    end
  end

  describe 'assembling the MaxL.asm program' do
    let(:test_name) { 'MaxL' }

    it 'returns the correct output' do
      expect(instance.assemble).to eq(expected_output)
    end
  end

  describe 'assembling the Pong.asm program' do
    let(:test_name) { 'Pong' }

    it 'returns the correct output' do
      expect(instance.assemble).to eq(expected_output)
    end
  end

  describe 'assembling the PongL.asm program' do
    let(:test_name) { 'PongL' }

    it 'returns the correct output' do
      expect(instance.assemble).to eq(expected_output)
    end
  end

  describe 'assembling the Rect.asm program' do
    let(:test_name) { 'Rect' }

    it 'returns the correct output' do
      expect(instance.assemble).to eq(expected_output)
    end
  end

  describe 'assembling the RectL.asm program' do
    let(:test_name) { 'RectL' }

    it 'returns the correct output' do
      expect(instance.assemble).to eq(expected_output)
    end
  end
end

def build_code_path(test_name)
  test_name = test_name[0..-2] if test_name[-1] == 'L'

  "./spec/support/#{test_name.downcase}/#{test_name}.asm"
end

def output_file(test_name)
  test_name = test_name[0..-2] if test_name[-1] == 'L'

  file = File.open("./spec/support/#{test_name.downcase}/#{test_name}.hack")
  file.readlines.map(&:strip)
end
