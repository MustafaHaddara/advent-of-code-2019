#!/usr/bin/env ruby

def vm(instructions, in_buff, out_buff)
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
            # puts "waiting for input"
            input = in_buff.shift()
            # puts "got input #{input}"
            instructions[arg1] = input.to_i
            ptr += 2
        elsif op == 4
            output = instructions[arg1]
            out_buff.push(output)
            # puts "output: #{output}"
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

def find_phase(instructions, itrs=5)
    max = nil
    best_phase = []
    5.times do |a|
        5.times do |b|
            if b == a
                next
            end
            5.times do |c|
                if c == b || c == a
                    next
                end
                5.times do |d|
                    if d == c || d == b || d == a
                        next
                    end
                    5.times do |e|
                        if e == d || e == c || e == b || e == a
                            next
                        end
                        phase = [a,b,c,d,e]
                        r = passthrough(instructions, phase)
                        # puts "phase: #{phase.to_s} r: #{r}"
                        if max == nil || max < r
                            max = r
                            best_phase = phase
                        end
                    end
                end
            end
        end
    end
    return max
end

def passthrough(instructions, phase)
    last_out = 0
    phase.each do |e|
        ins = instructions.clone
        out = []
        vm(ins, [e, last_out], out)
        last_out = out[0]
    end
    return last_out
end

if __FILE__ == $0
    instructions = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            instructions = line.split(",").map { |n| n.to_i } 
            break
        end
    end

    # phase: [1, 0, 4, 3, 1] r: 65216
    # phase: [1, 0, 4, 3, 2] r: 65210

    # puts passthrough(instructions, [1,0,4,3,1])
    # puts passthrough(instructions, [1,0,4,3,2])
    
    puts find_phase(instructions).to_s
end