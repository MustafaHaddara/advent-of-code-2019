#!/usr/bin/env ruby

class Moon
    attr_accessor :pos
    attr_accessor :v
    def initialize(pos)
        @pos = Vector3D.new(pos)
        @v = Vector3D.new([0,0,0])
    end

    def apply_gravity(other_moon)
        dx = sign(@pos.x - other_moon.pos.x)
        dy = sign(@pos.y - other_moon.pos.y)
        dz = sign(@pos.z - other_moon.pos.z)

        @v.x -= dx
        @v.y -= dy
        @v.z -= dz

        other_moon.v.x += dx
        other_moon.v.y += dy
        other_moon.v.z += dz
    end

    def move()
        @pos.x += @v.x
        @pos.y += @v.y
        @pos.z += @v.z
    end

    def potential_energy()
        return @pos.x.abs + @pos.y.abs + @pos.z.abs
    end

    def kinetic_energy()
        return @v.x.abs + @v.y.abs + @v.z.abs
    end

    def energy()
        return potential_energy() * kinetic_energy()
    end

    def to_s()
        return "#{@pos}|#{@v}"
    end

    def clone()
        return Moon.new([@pos.x,@pos.y,@pos.z])
    end
end

class Vector3D
    attr_accessor :x
    attr_accessor :y
    attr_accessor :z
    def initialize(coords)
        @x = coords[0]
        @y = coords[1]
        @z = coords[2]
    end
    def to_s()
        return "#{@x},#{@y},#{@z}"
    end
end

def sign(n)
    return n <=> 0
end

def parse_position(line)
    stripped = line[1..-2] # get rid of <>
    chunks = stripped.split(",")
    nums = []
    chunks.each do |c|
        bits = c.split("=")
        num = bits[1]
        nums.push(num.to_i)
    end
    return nums
end

def step(moons)
    for i in 0..moons.length-1
        m = moons[i]
        for j in i+1..moons.length-1
            other = moons[j]
            m.apply_gravity(other)
        end
    end
    moons.each do |m|
        m.move()
    end
end

def pp(moons)
    moons.each do |m|
        puts "#{m.pos.x},#{m.pos.y},#{m.pos.z} || #{m.v.x},#{m.v.y},#{m.v.z}"
    end
end

def state(moons)
    s = ""
    moons.each do |m|
        s += m.to_s + "."
    end
    return s
end

def find_repeat_state(moons)
    initial_moons = moons.map { |m| m.clone() }
    periods = [nil,nil,nil]
    num_steps = 0
    while true
        num_steps += 1
        step(moons)

        # x
        if periods[0] == nil
            xmatch = true
            4.times do |idx|
                current_moon = moons[idx]
                initial_state = initial_moons[idx]
                if !(current_moon.pos.x == initial_state.pos.x && current_moon.v.x == initial_state.v.x)
                    xmatch = false
                end
            end
            if xmatch
                periods[0] = num_steps
            end
        end

        # y
        if periods[1] == nil
            ymatch = true
            4.times do |idx|
                current_moon = moons[idx]
                initial_state = initial_moons[idx]
                if !(current_moon.pos.y == initial_state.pos.y && current_moon.v.y == initial_state.v.y)
                    ymatch = false
                end
            end

            if ymatch
                periods[1] = num_steps
            end
        end

        # z
        if periods[2] == nil
            zmatch = true
            4.times do |idx|
                current_moon = moons[idx]
                initial_state = initial_moons[idx]
                if !(current_moon.pos.z == initial_state.pos.z && current_moon.v.z == initial_state.v.z)
                    zmatch = false
                end
            end
            if zmatch
                periods[2] = num_steps
            end
        end

        if !periods.include?(nil)
            break
        end
    end
    return periods.reduce(1, :lcm)
end

if __FILE__ == $0
    moons = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            pos = parse_position(line.chomp)
            moons.push(Moon.new(pos))
        end
    end
    puts find_repeat_state(moons)
end