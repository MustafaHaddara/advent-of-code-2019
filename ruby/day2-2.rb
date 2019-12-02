#!/usr/bin/env ruby

def vm(instructions, noun=12, verb=2)
    instructions[1] = noun
    instructions[2] = verb

    ptr = 0
    while ptr < instructions.length do
        op = instructions[ptr]
        arg1 = instructions[ptr+1]
        arg2 = instructions[ptr+2]
        dst = instructions[ptr+3]
        
        if op == 1
            r = instructions[arg1] + instructions[arg2]
            instructions[dst] = r
        elsif op == 2
            r = instructions[arg1] * instructions[arg2]
            instructions[dst] = r
        elsif op == 99
            break
        else
            puts "wat"
        end
        ptr += 4
    end
    return instructions
end

def attempt(str_instructions)
    instructions = str_instructions.map { |n| n.to_i }

    return vm(instructions, 79, 60)[0]
end

if __FILE__ == $0
    total = 0
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            puts line
            puts attempt(line.split(","))
        end
      end
    puts total
end