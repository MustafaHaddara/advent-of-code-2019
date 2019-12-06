#!/usr/bin/env ruby

def add_orbit(existing_orbits, new_orbit)
    s = new_orbit.split(")")
    center = s[0]
    orbiter = s[1]
    existing_orbits[orbiter] = center
end

def count_orbits(orbits)
    counts = {}
    orbits.each do |key, value|
        if counts.key?(value)
            counts[key] = counts[value] + 1
        else
            counts[key] = count_orbit_for_thing(orbits, key)
        end
    end

    t = 0
    counts.each do |key,value|
        t+=value
    end

    return t
end

def count_orbit_for_thing(orbits, thing)
    if orbits.key?(thing)
        return 1 + count_orbit_for_thing(orbits, orbits[thing])
    else
        return 0
    end
end

if __FILE__ == $0
    orbits = {}
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            add_orbit(orbits, line.chomp)
        end
    end
    puts count_orbits(orbits)
end