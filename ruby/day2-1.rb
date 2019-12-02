#!/usr/bin/env ruby

def vm(instructions)
    instructions[1] = "12"
    instructions[2] = "2"

    ptr = 0
    while ptr < instructions.length do
        op = instructions[ptr].to_i
        arg1 = instructions[ptr+1].to_i
        arg2 = instructions[ptr+2].to_i
        dst = instructions[ptr+3].to_i
        
        if op == 1
            r = instructions[arg1].to_i + instructions[arg2].to_i
            instructions[dst] = r.to_s
        elsif op == 2
            r = instructions[arg1].to_i * instructions[arg2].to_i
            instructions[dst] = r.to_s
        else
            puts "wat"
        end
        ptr += 4
    end
    return instructions
end

if __FILE__ == $0
    total = 0
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            puts line
            puts vm(line.split(","))[0]
        end
      end
    puts total
end