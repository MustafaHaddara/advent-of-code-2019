#!/usr/bin/env ruby

class Point
    attr_accessor :x
    attr_accessor :y
    def initialize(x,y)
        @x = x
        @y = y
    end
end

class Line
    attr_accessor :a
    attr_accessor :b
    def initialize(a,b)
        @a = a
        @b = b
    end
end

def lines_overlap(line1, line2)
    if line2.a.x == line2.b.x
        # line2 is vertical
        if line1.a.x == line1.b.x
            # line1 is also vertical
            if (line1.a.x < line2.a.x && line1.a.x < line2.b.x) || (line1.a.x > line2.a.x && line1.a.x > line2.b.x)
                a = line1.b.x > line2.a.x && line1.b.x < line2.b.x 
                b = line1.b.x < line2.a.x && line1.b.x > line2.b.x 
                return a || b
            elsif (line1.b.x < line2.a.x && line1.b.x < line2.b.x) || (line1.b.x > line2.a.x && line1.b.x > line2.b.x)
                a = line1.a.x > line2.a.x && line1.a.x < line2.b.x 
                b = line1.a.x < line2.a.x && line1.a.x > line2.b.x 
                return a || b
            end
        else
            xcross = (line1.a.x < line2.a.x && line1.b.x > line2.a.x) || (line1.a.x > line2.a.x && line1.b.x < line2.a.x)
            ycross = (line2.a.y < line1.a.y && line2.b.y > line1.a.y) || (line2.a.y > line1.a.y && line2.b.y < line1.a.y)
            return xcross && ycross
        end
    else
        # line2 is horizontal
        if line1.a.y == line1.b.y
            # line1 is also horizontal
            if (line1.a.y < line2.a.y && line1.a.y < line2.b.y) || (line1.a.y > line2.a.y && line1.a.y > line2.b.y)
                a = line1.b.y > line2.a.y && line1.b.y < line2.b.y 
                b = line1.b.y < line2.a.y && line1.b.y > line2.b.y 
                return a || b
            elsif (line1.b.y < line2.a.y && line1.b.y < line2.b.y) || (line1.b.y > line2.a.y && line1.b.y > line2.b.y)
                a = line1.a.y > line2.a.y && line1.a.y < line2.b.y 
                b = line1.a.y < line2.a.y && line1.a.y > line2.b.y 
                return a || b
            end
        else
            xcross = (line2.a.x < line1.a.x && line2.b.x > line1.a.x) || (line2.a.x > line1.a.x && line2.b.x < line1.a.x)
            ycross = (line1.a.y < line2.a.y && line1.b.y > line2.a.y) || (line1.a.y > line2.a.y && line1.b.y < line2.a.y)
            return xcross && ycross
        end
    end
    return false
end

def parse_positions(line)
    directions = line.split(',')
    current = Point.new(0,0)
    all = []
    directions.each do |d|
        dist = d[1..-1].to_i
        if d[0] == 'R'
            n = Point.new(current.x+dist, current.y)
        elsif d[0] == 'L'
            n = Point.new(current.x-dist, current.y)
        elsif d[0] == 'U'
            n = Point.new(current.x, current.y+dist)
        elsif d[0] == 'D'
            n = Point.new(current.x, current.y-dist)
        else
            puts 'wat'
        end
        all.push(Line.new(current, n))
        current = n
    end
    return all
end

def find_overlaps(lines1, lines2)
    overlaps = []
    lines1.each do |line|
        lines2.each do |other|
            if lines_overlap(line, other)
                if line.a.x == line.b.x
                    # line is vertical
                    overlaps.push( Point.new(line.a.x, other.a.y) )
                else
                    overlaps.push( Point.new(other.a.x, line.a.y) )
                end
            end
        end
    end
    return overlaps
end

def find_closest_point(points)
    mindist = nil
    closest_point = nil
    points.each do |p|
        d = p.x.abs + p.y.abs
        if mindist == nil || mindist > d
            closest_point = p
            mindist = d
        end
    end
    return mindist
end

if __FILE__ == $0
    positions = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            positions.push( parse_positions(line) )
        end
      end
    overlaps = find_overlaps(positions[0], positions[1])
    puts overlaps.to_s
    puts find_closest_point(overlaps)
end