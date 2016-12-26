class Gene
  class Personality
    SIGMA = 0.2
    MIN = 0.0
    MAX = 1.0
    RANGE = MIN..MAX
    MU_RANGE = 0.3..0.7

    attr_reader :value

    def initialize( mu=nil )
      @mu     = mu || Random.rand( MU_RANGE )
      @rng    = RandomBell.new( mu: @mu, sigma: SIGMA, range: RANGE )
      @value  = @rng.rand
    end

    def to_sym
      if value <= 0.5
        return :hawk
      else
        return :dove
      end
    end
  end
end
