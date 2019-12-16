#!/usr/bin/env ruby

def fft(phase)
    pattern = [0,1,0,-1]

    result = []
    digits = phase.split("")
    digits.length.times do |i|
        val = 0
        inner_pattern = expand_pattern(pattern, i+1)
        pattern_idx = 1
        digits.length.times do |j|
            char = digits[j]
            pattern_val = inner_pattern[pattern_idx]
            val += (char.to_i * pattern_val)
            pattern_idx += 1
            pattern_idx = pattern_idx % inner_pattern.length
        end
        result.push(val.to_s[-1])
    end
    return result.join("")
end

def expand_pattern(pattern, n)
    result = []
    pattern.each do |c|
        result += ([c] * n)
    end
    return result
end

if __FILE__ == $0
    phase = nil
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            phase = line.strip
        end
    end

    100.times do
        phase = fft(phase)
    end
    puts phase[0..7]
end
