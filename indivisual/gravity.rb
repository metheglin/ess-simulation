# 中心にどの程度強くひきつけられるかを示した数値です.
# その個体の行動特性となります.
class Indivisual < Species
  class Gravity < Numeric

    SIGMA = 0.3
    MIN = 0.0
    MAX = 10.0
    RANGE = MIN..MAX
    MU_RANGE = (5.0-2.0)..(5.0+2.0)

    attr_reader :value

    def initialize( mu=nil )
      @mu     = mu || Random.rand( MU_RANGE )
      @rng    = RandomBell.new( mu: @mu, sigma: SIGMA, range: RANGE )
      @value  = @rng.rand
    end

    def +( gravity )
      value + (gravity.is_a?(Gravity) ? gravity.value : gravity)
    end

    def -( gravity )
      value - (gravity.is_a?(Gravity) ? gravity.value : gravity)
    end

    def *( gravity )
      value * (gravity.is_a?(Gravity) ? gravity.value : gravity)
    end

    def /( gravity )
      value / (gravity.is_a?(Gravity) ? gravity.value : gravity)
    end

    def to_f
      value.to_f
    end

    def to_s
      value.round(2)
    end
  end
end
