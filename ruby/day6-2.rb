#!/usr/bin/env ruby

def add_orbit(existing_orbits, new_orbit)
    s = new_orbit.split(")")
    center = s[0]
    orbiter = s[1]
    existing_orbits[orbiter] = center
end

def find_path(orbits)
    you = "YOU"
    santa = "SAN"

    santa_path = []
    santa_parent = orbits[santa]
    while santa_parent != nil
        santa_path.push(santa_parent)
        santa_parent = orbits[santa_parent]
    end

    your_parent = orbits[you]
    steps = 0
    while your_parent != nil
        idx = santa_path.index(your_parent)
        if idx == nil
            your_parent = orbits[your_parent]
            steps += 1
        else
            steps += idx
            break
        end
    end

    return steps
end

if __FILE__ == $0
    orbits = {}
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            add_orbit(orbits, line.chomp)
        end
    end
    puts find_path(orbits)
end