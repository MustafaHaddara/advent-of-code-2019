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

def flatten(layers)
    result = layers[0].clone

    for y in 0..HEIGHT-1
        row = result[y]
        for x in 0..WIDTH-1
            c = row[x]
            idx = 0
            while c == "2"
                idx += 1
                c = layers[idx][y][x]
            end
            row[x] = c
        end
    end
    return result
end

def pp(layers)
    for l in layers
        for c in l
            if c == "0"
                print " "
            else
                print c
            end
        end
        puts ""
    end
end

if __FILE__ == $0
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            layers = break_into_layers(line.chomp)
            pp(flatten(layers))
            break
        end
    end
    
end