# 最大まで広げられるなわばり半径です
class Gene
  class Life < Numeric

    SIGMA = 0.35
    MIN = 60.0
    MAX = 100.0
    RANGE = MIN..MAX
    MU_RANGE = (80-13)..(80+13)

    attr_reader :value

    def initialize( mu=nil )
      @mu     = mu || Random.rand( MU_RANGE )
      @rng    = RandomBell.new( mu: @mu, sigma: SIGMA, range: RANGE )
      @value  = @rng.rand
    end

    def +( compare )
      value + (compare.is_a?(self.class) ? compare.value : compare)
    end

    def -( compare )
      value - (compare.is_a?(self.class) ? compare.value : compare)
    end

    def *( compare )
      value * (compare.is_a?(self.class) ? compare.value : compare)
    end

    def /( compare )
      value / (compare.is_a?(self.class) ? compare.value : compare)
    end

    def to_f
      value.to_f
    end

    def to_s
      value.round(2)
    end
  end
end
