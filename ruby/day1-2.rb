#!/usr/bin/env ruby

def fuel(mass)
    return (mass / 3) - 2
end

def fueled(mass)
    t = fuel(mass)
    inc = t
    while true
        inc = fuel(inc)
        if inc > 0
            t += inc
        else
            break
        end
    end
    return t
end

if __FILE__ == $0
    total = 0
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            total += fueled(line.to_i)
        end
      end
    puts total
end