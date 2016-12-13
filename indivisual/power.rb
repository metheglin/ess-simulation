class Indivisual < Species
  class Power < Numeric

    SIGMA = 0.45
    MIN = 0.0
    MAX = 5.0
    RANGE = MIN..MAX
    MU_RANGE = (2.5-1.25)..(2.5+1.25)

    attr_reader :value

    def initialize( mu=nil )
      @mu     = mu || Random.rand( MU_RANGE )
      @rng    = RandomBell.new( mu: @mu, sigma: SIGMA, range: RANGE )
      @value  = @rng.rand
    end

    def +( power )
      value + (power.is_a?(Power) ? power.value : power)
    end

    def -( power )
      value - (power.is_a?(Power) ? power.value : power)
    end

    def *( power )
      value * (power.is_a?(Power) ? power.value : power)
    end

    def /( power )
      value / (power.is_a?(Power) ? power.value : power)
    end

    def to_f
      value.to_f
    end

    def to_s
      value.round(2)
    end
  end
end
