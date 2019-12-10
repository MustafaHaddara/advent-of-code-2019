#!/usr/bin/env ruby

def find_sightlines(grid)
    visible = []
    for y in 0..grid.length-1
        seen = []
        row = grid[y]
        for x in 0..row.length-1
            if grid[y][x] == "."
                seen.push(0)
                next
            end
            seen.push(num_visibile(grid, x, y))
        end
        visible.push(seen)
    end
    return visible
end

def num_visibile(grid, xpos, ypos)
    seen = {}
    total_visible = 0
    for y in 0..grid.length-1
        row = grid[y]
        for x in 0..row.length-1
            if ypos == y && xpos == x
                next
            end
            if grid[y][x] == "."
                next
            end
            dy = y-ypos
            dx = x-xpos
            gcd = dy.abs.gcd(dx.abs)

            ndy = dy/gcd
            ndx = dx/gcd

            if !seen.include?(ndy)
                seen[ndy] = {}
            end
            if !seen[ndy].include?(ndx)
                seen[ndy][ndx] = true
                total_visible += 1
            end
        end
    end
    return total_visible
end

def find_max_sightline(sightlines)
    best = 0
    sightlines.each do |s|
        if best < s.max
            best = s.max
        end
    end
    return best
end

if __FILE__ == $0
    grid = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            grid.push(line.chomp.split(""))
        end
    end
    sightlines = find_sightlines(grid)
    puts find_max_sightline(sightlines)
end