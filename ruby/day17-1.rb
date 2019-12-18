#!/usr/bin/env ruby

class IntCode
    def initialize(instructions, ptr=0, in_buff=[], out_buff=[], rel_base=0, blocked=false)
        @instructions = instructions
        @ptr = ptr
        @in_buff = in_buff
        @out_buff = out_buff
        @rel_base = rel_base
        @blocked = blocked
    end

    def clone()
        return IntCode.new(@instructions.clone, @ptr, @in_buff.clone, @out_buff.clone, @rel_base, @blocked)
    end

    def send_input(thing)
        @in_buff.push(thing)
    end

    def read_output()
        return @out_buff.shift()
    end

    def all_output()
        return @out_buff
    end

    def inspect()
        puts @instructions.to_s
        puts @out_buff.to_s
    end

    def isBlocked()
        return @blocked
    end

    def read_mem(idx)
        if idx < 0
            puts "wat: negative index"
        end
        val = @instructions[idx]
        if val == nil
            @instructions[idx] = 0
            return 0
        else
            return val
        end
    end

    def run()
        @blocked = false
        while @ptr < @instructions.length do
            # puts @ptr, @instructions.to_s
            base_op = read_mem(@ptr)
            # puts base_op
            op = base_op % 100  # get last 2 digits
            flags = base_op / 100 # top n digits
            arg1 = read_value(@instructions, @ptr+1, flags%10)
            if op == 1
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                flags = flags / 10
                arg3 = read_value(@instructions, @ptr+3, flags%10)
                r = read_mem(arg1) + read_mem(arg2)
                @instructions[arg3] = r
                @ptr += 4
            elsif op == 2
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                flags = flags / 10
                arg3 = read_value(@instructions, @ptr+3, flags%10)
                r = read_mem(arg1) * read_mem(arg2)
                @instructions[arg3] = r
                @ptr += 4
            elsif op == 3
                if @in_buff.empty?
                    # puts "waiting for input"
                    @blocked = true
                    return false
                end
                input = @in_buff.shift()
                # puts "got input #{input}, putting in location #{arg1}"
                @instructions[arg1] = input.to_i
                @ptr += 2
            elsif op == 4
                output = read_mem(arg1)
                @out_buff.push(output)
                # puts "output: #{output}"
                @ptr += 2
            elsif op == 5
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                if read_mem(arg1) != 0
                    @ptr = read_mem(arg2)
                else
                    @ptr += 3
                end
            elsif op == 6
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                if read_mem(arg1) == 0
                    @ptr = read_mem(arg2)
                else
                    @ptr += 3
                end
            elsif op == 7
                flags = flags / 10
                arg2 = read_value(@instructions, @ptr+2, flags%10)
                flags = flags / 10
                arg3 = read_value(@instructions, @ptr+3, flags%10)
                if read_mem(arg1) < read_mem(arg2)
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
                if read_mem(arg1) == read_mem(arg2)
                    @instructions[arg3] = 1
                else
                    @instructions[arg3] = 0
                end
                @ptr += 4
            elsif op == 9
                @rel_base += read_mem(arg1)
                # puts "updated relative base to #{@rel_base}"
                @ptr += 2
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

    def read_value(instructions, arg, flag)
        if flag == 1
            return arg
        elsif flag == 2
            v = read_mem(arg) + @rel_base
            return v
        else
            return read_mem(arg)
        end
    end
end

def find_intersections(vm)
    vm.run()
    out = vm.all_output()
    rows = []
    row = []
    out.each do |c|
        v = c.chr
        if c == 10
            rows.push(row)
            row = []
        else
            row.push(v)
        end
    end

    total = 0
    rows.each_with_index do |row,y|
        row.each_with_index do |thing,x|
            if rows[y-1] == nil || rows[y+1] == nil || thing != '#'
                next
            end
            if rows[y-1][x] == '#' && rows[y+1][x] == '#' && rows[y][x-1] == '#' && rows[y][x+1] == '#'
                total += y*x
            end
        end
    end
    return total
end

if __FILE__ == $0
    instructions = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            instructions = line.split(",").map { |n| n.to_i } 
            break
        end
    end

    vm = IntCode.new(instructions)
    puts find_intersections(vm)
end