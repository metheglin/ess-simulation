require "json"
require "./indivisual.rb"
require 'histogram/array'

class SelectionRule
  class << self
    def main( indiv_count: 100, step_count: 1000 )
      indiv_count.times do |i|
        Indivisual.new( name: i )
      end

      print_snapshot

      print_result

      step_count.times do |i|
        Species.bruteforce do |indiv1, indiv2|
          if indiv1.in?( indiv2 )
            Indivisual.conbat!( indiv1, indiv2 )
          end
        end
        Species.each do |indiv|
          indiv.step!
        end
        print_snapshot(i)
      end

      # Species.each do |indiv|
      #   puts indiv.to_s
      # end

      print_result
    end

    def print_snapshot( number=0 )
      data = {
        no: number,
        total: Species.count,
        hawk: Species.count{|i| i.strategy == :hawk}.to_s,
        dove: Species.count{|i| i.strategy == :dove}.to_s,
        power: Species.avg(&:power).round(2).to_s,
        center_distance: Species.avg(&:center_distance).round(2).to_s,
        max_territory: Species.avg(&:max_territory).round(2).to_s,
        life: Species.avg(&:life).round(2).to_s,
      }
      puts data.to_json
    end

    def print_result
      print_easy_histogram( :center_distance, dist:8, min:0, max: 3500 )
      print_gene_histogram( :gravity )
      print_gene_histogram( :power )
      print_gene_histogram( :max_territory )
      print_gene_histogram( :life )
      print_gene_histogram( :personality )
    end

    def print_gene_histogram( property )
      klass_name = property.to_s.split(/[^[:alnum:]]+/).map(&:capitalize).join
      klass   = Gene.const_get klass_name
      values = Species.map{|i| i.send(property).value}
      puts "=== #{property} ==="
      print_histogram( values, 8, klass::MIN, klass::MAX )
    end

    def print_easy_histogram( property, **args )
      default_args = {
        dist: 8, min: 0, max: 1000
      }
      args = default_args.merge args
      values = Species.map{|i| i.send(property)}
      puts "=== #{property} ==="
      print_histogram( values, *args.values )
    end

    def print_histogram( values, dist, min, max )
      (bins, freqs) = values.histogram( dist, min: min, max: max )
      histogram = bins.zip( freqs )
      
      histogram.each do |g|
        label = "%4d.2" % g[0].round(2)
        score = '*' * (g[1].to_f / 3.0)
        puts "#{label}: #{score}"
      end
    end
  end

end

SelectionRule.main
