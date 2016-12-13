require "json"
require "./indivisual.rb"
require 'histogram/array'

class SelectionRule
  # 個体が生まれたときのポイント
  POINT_DEFAULT = 0
  # 
  POINT_WIN = 100
  POINT_LOSE = -100
  POINT_ENDURE = -10

  class << self
    def main
      # 個体数=100
      100.times do |i|
        Indivisual.new( name: i )
      end

      # puts "-------------"
      # puts "total: #{Species.count}"
      # puts "hawk: " + Species.count{|i| i.strategy == :hawk}.to_s +
      #   ", dove: " + Species.count{|i| i.strategy == :dove}.to_s
      # puts "power average: " + Species.avg(&:power).to_s
      # puts "point average: " + Species.avg(&:point).to_s
      # puts "center distance average: " + Species.avg(&:center_distance).to_s
      print_snapshot

      print_result

      300.times do |i|
        Species.bruteforce do |indiv1, indiv2|
          if indiv1.in?( indiv2 )
            Indivisual.conbat!( indiv1, indiv2 )
          end
        end
        Species.each do |indiv|
          indiv.step!
        end
        print_snapshot(i)
        # puts "--- Step over... ---"
        # puts "total: #{Species.count}"
        # puts "hawk: " + Species.count{|i| i.strategy == :hawk}.to_s +
        #   ", dove: " + Species.count{|i| i.strategy == :dove}.to_s
        # puts "power average: " + Species.avg(&:power).to_s
        # puts "point average: " + Species.avg(&:point).to_s
        # puts "gravity average: " + Species.avg(&:gravity).to_s
        # puts "center distance average: " + Species.avg(&:center_distance).to_s
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
        power: Species.avg(&:power).to_s,
        center_distance: Species.avg(&:center_distance).to_s
      }
      puts data.to_json
    end

    def print_result
      print_easy_histogram( :center_distance, dist:8, min:0, max: 3000 )
      print_gene_histogram( :gravity )
      print_gene_histogram( :power )
    end

    def print_gene_histogram( property )
      klass_name = property.to_s.split(/[^[:alnum:]]+/).map(&:capitalize).join
      klass   = Indivisual.const_get klass_name
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
        score = '*' * (g[1].to_f / 2.0)
        puts "#{label}: #{score}"
      end
    end
  end

end

SelectionRule.main
