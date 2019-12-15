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
        num_needed = chem_num - @leftovers[chem_name]
        @leftovers[chem_name] = [@leftovers[chem_name] - chem_num, 0].max

        if num_needed <= 0
            return
        end

        recipe = @deps[chem_name]
        num_produced = recipe["produces"]
        while num_needed > 0
            recipe["needs"].each do |source|
                if source.name == "ORE"
                    @total_cost += source.num
                else
                    make(source.name, source.num)
                end
            end
            num_needed -= num_produced
        end

        # num_needed <= 0
        @leftovers[chem_name] -= num_needed
    end

    def cost()
        return @total_cost
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
    puts factory.cost()
end