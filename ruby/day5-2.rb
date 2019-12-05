#!/usr/bin/env ruby

def vm(instructions)
    ptr = 0
    while ptr < instructions.length do
        # puts ptr, instructions.to_s
        base_op = instructions[ptr]
        op = base_op % 100  # get last 2 digits
        flags = base_op / 100 # top n digits
        arg1 = read_value(instructions, ptr+1, flags%10)
        if op == 1
            flags = flags / 10
            arg2 = read_value(instructions, ptr+2, flags%10)
            flags = flags / 10
            arg3 = read_value(instructions, ptr+3, flags%10)
            r = instructions[arg1] + instructions[arg2]
            instructions[arg3] = r
            ptr += 4
        elsif op == 2
            flags = flags / 10
            arg2 = read_value(instructions, ptr+2, flags%10)
            flags = flags / 10
            arg3 = read_value(instructions, ptr+3, flags%10)
            r = instructions[arg1] * instructions[arg2]
            instructions[arg3] = r
            ptr += 4
        elsif op == 3
            puts "waiting for input"
            input = $stdin.gets
            # puts "got input #{input}"
            instructions[arg1] = input.to_i
            ptr += 2
        elsif op == 4
            output = instructions[arg1]
            puts "output: #{output}"
            ptr += 2
        elsif op == 5
            flags = flags / 10
            arg2 = read_value(instructions, ptr+2, flags%10)
            if instructions[arg1] != 0
                ptr = instructions[arg2]
            else
                ptr += 3
            end
        elsif op == 6
            flags = flags / 10
            arg2 = read_value(instructions, ptr+2, flags%10)
            if instructions[arg1] == 0
                ptr = instructions[arg2]
            else
                ptr += 3
            end
        elsif op == 7
            flags = flags / 10
            arg2 = read_value(instructions, ptr+2, flags%10)
            flags = flags / 10
            arg3 = read_value(instructions, ptr+3, flags%10)
            if instructions[arg1] < instructions[arg2]
                instructions[arg3] = 1
            else
                instructions[arg3] = 0
            end
            ptr += 4
        elsif op == 8
            flags = flags / 10
            arg2 = read_value(instructions, ptr+2, flags%10)
            flags = flags / 10
            arg3 = read_value(instructions, ptr+3, flags%10)
            if instructions[arg1] == instructions[arg2]
                instructions[arg3] = 1
            else
                instructions[arg3] = 0
            end
            ptr += 4
        elsif op == 99
            break
        else
            puts "wat"
            return instructions
        end
    end
    return instructions
end

def read_value(instructions, arg, flag)
    if flag == 1
        return arg
    else
        return instructions[arg]
    end
end

if __FILE__ == $0
    instructions = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            instructions = line.split(",").map { |n| n.to_i } 
            break
        end
    end
    vm(instructions)  
end