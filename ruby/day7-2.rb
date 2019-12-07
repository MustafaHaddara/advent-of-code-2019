#!/usr/bin/env ruby

class IntCode
    def initialize(instructions)
        @instructions = instructions
        @ptr = 0
        @in_buff = []
        @out_buff = []
        @blocked = false
    end

    def send_input(thing)
        @in_buff.push(thing)
    end

    def read_output()
        return @out_buff.shift()
    end

    def isBlocked()
        return @blocked
    end

    def run()
        @blocked = false
        while @ptr < @instructions.length do
            # puts @ptr, @instructions.to_s
            base_op = @instructions[@ptr]
            op = base_op % 100  # get last 2 digits
            flags = base_op / 100 # top n digits
            arg1 = read_value(@instructions, @ptr+1, flags%10)
            if op == 1
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                flags = flags / 10
                arg3 = read_value(@instructions, @ptr+3, flags%10)
                r = @instructions[arg1] + @instructions[arg2]
                @instructions[arg3] = r
                @ptr += 4
            elsif op == 2
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                flags = flags / 10
                arg3 = read_value(@instructions, @ptr+3, flags%10)
                r = @instructions[arg1] * @instructions[arg2]
                @instructions[arg3] = r
                @ptr += 4
            elsif op == 3
                if @in_buff.empty?
                    # puts "waiting for input"
                    @blocked = true
                    return false
                end
                input = @in_buff.shift()
                # puts "got input #{input}"
                @instructions[arg1] = input.to_i
                @ptr += 2
            elsif op == 4
                output = @instructions[arg1]
                @out_buff.push(output)
                # puts "output: #{output}"
                @ptr += 2
            elsif op == 5
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                if @instructions[arg1] != 0
                    @ptr = @instructions[arg2]
                else
                    @ptr += 3
                end
            elsif op == 6
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                if @instructions[arg1] == 0
                    @ptr = @instructions[arg2]
                else
                    @ptr += 3
                end
            elsif op == 7
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                flags = flags / 10
                arg3 = read_value(@instructions, @ptr+3, flags%10)
                if @instructions[arg1] < @instructions[arg2]
                    @instructions[arg3] = 1
                else
                    @instructions[arg3] = 0
                end
                @ptr += 4
            elsif op == 8
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                flags = flags / 10
                arg3 = read_value(@instructions, @ptr+3, flags%10)
                if @instructions[arg1] == @instructions[arg2]
                    @instructions[arg3] = 1
                else
                    @instructions[arg3] = 0
                end
                @ptr += 4
            elsif op == 99
                # puts "halting!"
                break
            else
                puts "wat"
                return @instructions
            end
        end
        return @instructions
    end
end

def read_value(instructions, arg, flag)
    if flag == 1
        return arg
    else
        return instructions[arg]
    end
end

def find_phase(instructions)
    max = nil
    best_phase = []
    for a in 5..9
        for b in 5..9
            if b == a
                next
            end
            for c in 5..9
                if c == b || c == a
                    next
                end
                for d in 5..9
                    if d == c || d == b || d == a
                        next
                    end
                    for e in 5..9
                        if e == d || e == c || e == b || e == a
                            next
                        end
                        phase = [a,b,c,d,e]
                        r = feedback(instructions, phase)
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

def feedback(instructions, phase)
    vms = []
    phase.each do |e|
        ins = instructions.clone
        vms.push(IntCode.new(ins))
    end

    last_out = 0
    runs = 0
    while true
        # puts last_out
        for i in 0..phase.length-1
            p = phase[i]
            vm = vms[i]

            # puts "inputs #{p}, #{last_out}"

            if runs == 0
                vm.send_input(p)
            else
                vm.send_input(last_out)
            end
            
            vm.run()
            out = vm.read_output()
            if out != nil
                last_out = out
            end
        end

        if !vms[4].isBlocked
            break
        end
        runs += 1
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

    puts find_phase(instructions).to_s
end