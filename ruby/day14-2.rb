#!/usr/bin/env ruby

CHEMICALS = []

class Chemical
    attr_accessor :num
    attr_accessor :name
    def initialize(str)
        @str = str
        chunk = str.split(" ")
        @num = chunk[0].to_i
        @name = chunk[1].chomp
        if !CHEMICALS.include?(@name)
            CHEMICALS.push(@name)
        end
    end
    def ==(other)
        if other.respond_to?( :num ) && other.respond_to?( :name )
            return other.num == @num && other.name == @name
        end
        return false
    end
    def hash()
        return @num * 1000 + CHEMICALS.index(@name)
    end
    def to_s()
        return @str
    end
end

class ChemicalFactory
    def initialize(rows)
        @deps = {}
        @leftovers = {}
        @total_cost = 0
        build_deps(rows)
    end

    def build_deps(rows)
        rows.each do |row|
            chunk = row.split("=>")
            sources = [] 
            chunk[0].split(",").each do |s|
                sources.push(Chemical.new(s.strip))
            end
            dest = Chemical.new(chunk[1].strip)
            if !@deps.include?(dest.name)
                @deps[dest.name] = {}
                @leftovers[dest.name] = 0
            end
            @deps[dest.name] = {
                "produces" => dest.num,
                "needs" => sources
            }
        end
    end

    def make(chem_name, chem_num)
        recipe = @deps[chem_name]
        existing = @leftovers[chem_name]
        num_produced = recipe['produces']
        num_needed = [chem_num - existing, 0].max
        num_reactions = (num_needed / num_produced.to_f).ceil
        extra = (num_produced * num_reactions) - (chem_num - existing)

        if chem_name != 'ORE'
            @leftovers[chem_name] = extra
        end

        recipe['needs'].each do |source|
            if source.name == 'ORE'
                @total_cost += num_reactions * source.num
            else
                make(source.name, num_reactions * source.num)
            end
        end
    end

    def remainders()
        return @leftovers
    end
    def cost()
        return @total_cost
    end
end

def bin_search(rows, start, stop, maxcost)
    mid = (stop + start) / 2

    factory = ChemicalFactory.new(rows)
    factory.make("FUEL", mid)
    c = factory.cost()
    # puts "tried #{mid}, cost was #{c}"
    if c > maxcost
        if mid == start+1
            return start
        else
            return bin_search(rows, start, mid, maxcost)
        end
    else
        if mid == stop-1
            return mid
        else
            return bin_search(rows, mid, stop, maxcost)
        end
    end
end

if __FILE__ == $0
    rows = []
    File.open(ARGV[0], "r") do |file_handle|
        file_handle.each_line do |line|
            rows.push(line.strip)
        end
    end

    factory = ChemicalFactory.new(rows)
    factory.make("FUEL", 1)
    cost_for_1 = factory.cost()
    trillion = 1000000000000
    puts bin_search(rows, trillion/cost_for_1, 5 * trillion/cost_for_1, trillion)
end