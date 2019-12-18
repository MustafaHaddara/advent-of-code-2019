#!/usr/bin/env ruby

def fft_inc(phase, offset)
    pattern = [0,1,0,-1]

    result = []
    digits = phase.split("")

    # total_length = digits.length * 10000
    num_iterations = digits.length - offset

    num = nil
    num_iterations.times do |idx|
        i = idx + offset

        if num == nil
            num = digits[i..-1].map{|d| d.to_i}.sum
        else
            num = num - digits[i-1].to_i
        end

        result.push(num % 10)
    end

    return ("X" * offset) + result.join("")
end


def fft_10k(phase)
    pattern = [0,1,0,-1]

    result = []
    digits = phase.split("")

    total_length = digits.length * 10000
    
    # i = idx of produced digit
    total_length.times do |i|
        val = 0
        pattern_idx = 1
        num_times = 0

        pattern_length = pattern.length * (i+1)
        m = pattern_length.lcm(2 * digits.length)
        n = m * pattern_length / (2 * digits.length)

        max_repeat_offset = n * digits.length

        # j = idx of input digit
        if max_repeat_offset > total_length
            j = i
        else
            j = max_repeat_offset
        end
        puts j

        while j < total_length
            (i+1).times do |a|
                char = digits[j]
                pattern_idx = ((j+1) / (i+1)) % pattern.length
                pattern_val = pattern[pattern_idx]
                # print "#{char} * #{pattern_val} + "
                val += (char.to_i * pattern_val)
                num_times += 1
                j += 1
            end
            j += (i+1)
        end

        result.push(val.to_s[-1])
        # puts "= #{val.to_s[-1]}"
        if i % 1000 == 0
            puts i
        end
    end
    return result.join("")
end

if __FILE__ == $0
    phase = nil
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            phase = line.strip
        end
    end

    # phase = "03036732577212944063491565474664"

    full_phase = phase * 10000
    offset = phase[0..6].to_i

    100.times do
        full_phase = fft_inc(full_phase, offset)
        puts full_phase[offset..offset+7]
        # full_phase = vertical_fft(full_phase)
    end
    puts full_phase[offset..offset+7]
end
