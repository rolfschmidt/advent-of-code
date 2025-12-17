
class Day07 < Helper
  def self.amp_sequence_list_get(from, to)
    (from..to).to_a.permutation(5).to_a
  end

  def self.amp_run(code, sequences)
    outputs = []

    sequences.each do |sequence|
      amp_outputs = 0
      index_memory = {}
      index_code = {}
      amp_index = 0
      while amp_index < 5 do
        index_memory[amp_index] ||= 0
        index_code[amp_index] ||= code.clone

        sequence_value = sequence[amp_index]
        ra = Machine.new(index_code[amp_index].clone).compute(input: [sequence_value, amp_outputs], all: true, init_index: index_memory[amp_index])

        amp_outputs = ra[:output] if !ra[:output].nil?

        outputs << amp_outputs

        raise 'next_seq' if ra[:halted] && amp_index == 4 && part2?

        if part2?
          index_memory[amp_index] = ra[:index]
          index_code[amp_index] = ra[:parts]

          if amp_index == 4
            amp_index = 0
            next
          end
        end

        amp_index += 1
      end

    rescue => e
      next if e.message == 'next_seq'
      raise e
    end

    outputs
  end

  def self.part1
    code = file.split(/,/).map(&:to_i)
    amp_run(code, amp_sequence_list_get(0, 4)).max
  end

  def self.part2
    code = file.split(/,/).map(&:to_i)
    amp_run(code, amp_sequence_list_get(5, 9)).max
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq(262086)
  end

  it "does part 2" do
    expect(Day07.part2).to eq(5371621)
  end
end
