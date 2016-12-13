# 1度の移動距離平均です.
class Indivisual < Species
  class Reach < Numeric

    SIGMA = 0.3
    MIN = 10.0
    MAX = 100.0
    RANGE = MIN..MAX
    MU_RANGE = (65-10)..(65+10)

    attr_reader :value

    def initialize( mu=nil )
      @mu     = mu || Random.rand( MU_RANGE )
      @rng    = RandomBell.new( mu: @mu, sigma: SIGMA, range: RANGE )
      @value  = @rng.rand
    end

    def +( reach )
      value + (reach.is_a?(Reach) ? reach.value : reach)
    end

    def -( reach )
      value - (reach.is_a?(Reach) ? reach.value : reach)
    end

    def *( reach )
      value * (reach.is_a?(Reach) ? reach.value : reach)
    end

    def /( reach )
      value / (reach.is_a?(Reach) ? reach.value : reach)
    end

    def to_f
      value.to_f
    end

    def to_s
      value.round(2)
    end
  end
end
