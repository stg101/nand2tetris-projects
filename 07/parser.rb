class Parser
  attr_accessor :content, :cursor

  def initialize(file)
    @content = clean(file.readlines)
    @cursor = 0
  end

  def finished?
    content.length == cursor
  end

  def parse_next
    result = content[cursor]
    @cursor += 1
    result
  end

  private

  def clean(text)
    text.map do |line|
      new_line = clean_line(line)
      next nil if new_line.empty?

      new_line
    end.compact
  end

  def clean_line(str)
    str.split('//').first.split(' ')
  end
end
