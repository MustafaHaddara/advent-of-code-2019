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

def find_best_position(sightlines)
    best = 0
    best_loc = nil
    for y in 0..sightlines.length-1
        row = sightlines[y]
        for x in 0..row.length-1
            if best < row[x]
                best = row[x]
                best_loc = [x,y]
            end
        end
    end
    return best_loc
end

def get_rays(grid, xpos, ypos)
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

            theta = Math.atan2(ndx, ndy)

            if !seen.include?( theta )
                seen[ theta ] = []
            end
            seen[ theta ].push([x,y])
        end
    end
    # puts seen.to_s
    # puts seen.keys.sort
    # puts seen[0.0].to_s
    # puts seen[0.12435499454676144].to_s
    return seen
end

def dist(a,b)
    return (a[0]-b[0]).abs + (a[1]-b[1]).abs
end

def compare_by_dist(a,b, best_location)
    if dist(a, best_location) < dist(b, best_location)
        return -1
    else
        return 1
    end
end

def vaporize_200(rays, best_location)
    ordering = rays.keys.sort

    start = ordering.length-1 #ordering.index(0.0)
    pos = start
    num_vaporized = 0
    last_vaporized = nil
    while num_vaporized < 200
        key = ordering[pos]
        sorted = rays[key].sort { |a,b| compare_by_dist(a,b, best_location) }
        puts "#{pos}, #{key}: #{rays[key].to_s} |>> #{sorted}"
        last_vaporized = sorted.shift()
        num_vaporized += 1
        puts "vaporizing #{last_vaporized}"

        pos -= 1
        if pos == 0
            pos = ordering.length-1
        elsif pos == start
            # break
        end
    end

    return last_vaporized
end

if __FILE__ == $0
    grid = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            grid.push(line.chomp.split(""))
        end
    end
    sightlines = find_sightlines(grid)
    best_location = find_best_position(sightlines)
    puts best_location.to_s

    rays = get_rays(grid, best_location[0], best_location[1])
    last = vaporize_200(rays, best_location)
    puts (last[0] * 100) + last[1]
end