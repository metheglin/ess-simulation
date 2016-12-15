require "matrix"
require "random_bell"

# require_relative "./strategies/hawk_strategy.rb"
# require_relative "./strategies/dove_strategy.rb"
require "./species.rb"
require "./gene.rb"

# require "./indivisual.rb"
# i=Indivisual.new(pos: Vector[0,0])
# i.move!

class Indivisual < Species

  autoload :Personality, File.expand_path('../indivisual/personality', __FILE__) 
  autoload :Power, File.expand_path('../indivisual/power', __FILE__)
  autoload :Reach, File.expand_path('../indivisual/reach', __FILE__)
  autoload :Gravity, File.expand_path('../indivisual/gravity', __FILE__)
  autoload :MaxTerritory, File.expand_path('../indivisual/max_territory', __FILE__)
  autoload :Life, File.expand_path('../indivisual/life', __FILE__)

  # stock
  DEFAULT_POINT = 0

  # 平均移動距離
  DISTANCE_AVG_MOVE = 300.0

  # 最低限保障されるなわばり
  SAFE_TERRITORY = 30.0

  attr_reader :personality, :power, :reach, :gravity, :max_territory, :life
  attr_reader :name, :pos, :velocity, :current_life, :current_territory
  attr_accessor :conbat_count, :birth_count
  attr_reader :lost_point, :impact_velocity
  attr_accessor :point

  attr_accessor :win_log, :lose_log, :step_log, :birth_log

  class << self
    def destination_delta( reach=nil, direction=nil )
      reach     ||= DISTANCE_AVG_MOVE
      direction ||= (( Random.new.rand(360.0) ) / 360.0).to_f * (2 * Math::PI)
      distance  = reach * Random.new.rand(2.0)
      Vector[distance*Math.cos(direction), distance*Math.sin(direction)]
    end

    def conbat!( indiv1, indiv2 )
      indiv1.conbat_count += 1
      indiv2.conbat_count += 1

      if indiv1.strategy == :hawk && indiv2.strategy == :hawk
        # powerによって勝敗の確率が決まる
        p = 0.5 + (((indiv1.power - indiv2.power) / Indivisual::Power::MAX) * 0.4)
        if Random.new.rand(1.0) <= p
          indiv1.win!( 100 )
          indiv2.lose!( 35 )
        else
          indiv1.lose!( 35 )
          indiv2.win!( 100 )
        end
      elsif indiv1.strategy == :hawk && indiv2.strategy == :dove
        indiv1.win!( 100 )
        indiv2.lose!( 0 )
      elsif indiv1.strategy == :dove && indiv2.strategy == :hawk
        indiv1.lose!( 0 )
        indiv2.win!( 100 )
      elsif indiv1.strategy == :dove && indiv2.strategy == :dove
        # powerによって勝敗の確率が決まる
        p = 0.5 + (((indiv1.power - indiv2.power) / Indivisual::Power::MAX) * 0.4)
        if Random.new.rand(1.0) <= p
          indiv1.win!( 100-10 )
          indiv2.lose!( 1 )
        else
          indiv1.lose!( 1 )
          indiv2.win!( 100-10 )
        end
      end
    end
  end

  def initialize( **args )
    # Congenital
    @gene           = args[:gene] || Gene.random
    @personality    = Personality.new( @gene.personality )
    @power          = Power.new( @gene.power )
    @reach          = Reach.new( @gene.reach )
    @gravity        = Gravity.new( @gene.gravity )
    @max_territory  = MaxTerritory.new( @gene.max_territory )
    @life           = Life.new( @gene.life )

    # Acquired
    @name         = args[:name] || object_id
    @pos          = self.class.destination_delta( @reach.value*3 )
    @velocity     = self.class.destination_delta( @reach.value )
    @point        = DEFAULT_POINT
    @current_life = @life.value
    @current_territory = 0
    @conbat_count = 0
    @birth_count  = 0

    reset_log!
    reset_step!

    join_to_species
  end

  def strategy
    @personality.to_sym
  end

  def status
    {
      name: name,
      strategy: strategy,
      power: power.to_s,
      point: point,
      current_life: current_life,
      conbat_count: conbat_count,
      birth_count: birth_count,
      neighbors: neighbors.length
    }
  end

  def to_s
    "#{name} #{strategy} power:#{power.to_s} point:#{point} current_life:#{current_life} " +
    "conbat:#{conbat_count} neighbors:#{neighbors.length}"
  end

  def join_to_species
    indiv = Species.last
    indiv.next = self
    self.back = indiv
  end

  def center_distance
    pos.r
  end

  def territory
    score = (current_territory >= 0) ? current_territory : 0
    if score + SAFE_TERRITORY > max_territory.value
      return max_territory.value
    else
      return score + SAFE_TERRITORY
    end
  end

  # 移動します
  def move!
    delta_v   = -1.0 * @gravity * pos.normalize
    @velocity += delta_v
    @velocity += impact_velocity
    @pos      += velocity
  end

  # なわばり内の判定をおこないます.
  def in?( indiv )
    (pos - indiv.pos).r <= reach
  end

  def win!( bonus )
    @win_log += 1
    @current_territory += 1
  end

  def lose!( penalty )
    @lose_log += 1
    @current_territory -= 4
    @lost_point += penalty
    @impact_velocity += (gravity*0.5) * pos.normalize
  end

  def harvest!
    d = 1.001 ** (-1.0 * center_distance)
    d = territory * d
    @point += d
  end

  def die!
    self.back.next = self.next
    if self.next
      self.next.back = self.back
    end
  end

  def birth!
    @birth_log += 1
    @current_territory += 1
    new_gene = @gene.generate!
    Indivisual.new( gene: new_gene )
    @point -= 800
    @birth_count += 1
  end

  def step!
    @step_log += 1
    @current_territory += 3
    @current_life -= 1 # Penalty of arrival
    if @lost_point > 0
      @current_life -= 1 # Penalty of move
      @current_life -= @lost_point # Penalty of defeat of conbat
    end

    die! if @current_life <= 0

    harvest!

    birth! if @point >= 800

    move!

    reset_step!
  end

  def reset_step!
    @lost_point = 0
    @impact_velocity = Vector[0.0, 0.0]
  end

  def reset_log!
    @win_log = 0
    @lose_log = 0
    @step_log = 0
    @birth_log = 0
  end

  def neighbors
    Species.select do |indiv|
      self.in? indiv
    end
  end

  # なわばり内に別の個体がいないかパトロールします
  def patrol
    neighbors = Species.select do |indiv|
      (pos - indiv.pos).r <= reach
    end
    neighbors.select do |n|
      !( self.equal? n )
    end
  end

end
