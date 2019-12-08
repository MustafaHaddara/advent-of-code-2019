#!/usr/bin/env ruby

WIDTH = 25
HEIGHT = 6

def break_into_layers(line)
    layers = []
    img = []
    row = []

    for p in 0..line.length
        row.push(line[p])

        if row.length == WIDTH
            img.push(row)
            row = []
        end
        if img.length == HEIGHT
            layers.push(img)
            img = []
        end
    end
    return layers
end

def find_fewest_zeros(layers)
    min = nil
    layer = nil
    for img in layers
        total = 0
        img.each do |row|
            row.each do |c|
                if c == "0"
                    total += 1
                end
            end
        end
        if min == nil || total < min
            min = total
            layer = img
        end
    end
    return layer
end

def sum_1_2(layer)
    ones = 0
    twos = 0
    layer.each do |row|
        row.each do |c|
            if c == "1"
                ones += 1
            end
            if c == "2"
                twos += 1
            end
        end
    end
    return ones * twos
end

if __FILE__ == $0
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            layers = break_into_layers(line.chomp)
            fewest_zeroes = find_fewest_zeros(layers)
            puts sum_1_2(fewest_zeroes)
            break
        end
    end
    
end