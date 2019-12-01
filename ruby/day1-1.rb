#!/usr/bin/env ruby

def fuel(mass)
    return (mass / 3) - 2
end

if __FILE__ == $0
    total = 0
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            total += fuel(line.to_i)
        end
      end
    puts total
end