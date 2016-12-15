require "./indivisual.rb"

class Gene < Struct.new( 
  :personality, 
  :power, 
  :reach, 
  :gravity, 
  :max_territory, 
  :life 
)

  SIGMA = 0.2
  RANGE = 0.0..5.0

  class << self
    def random
      new( 
        Random.rand( Indivisual::Personality::MU_RANGE ),
        Random.rand( Indivisual::Power::MU_RANGE ),
        Random.rand( Indivisual::Reach::MU_RANGE ),
        Random.rand( Indivisual::Gravity::MU_RANGE ),
        Random.rand( Indivisual::MaxTerritory::MU_RANGE ),
        Random.rand( Indivisual::Life::MU_RANGE )
      )
    end
  end

  # Produce the next generation
  def generate!
    avg_range_person = (Indivisual::Personality::MU_RANGE.last - Indivisual::Personality::MU_RANGE.first) / 2
    mu_person = avg_range_person + (personality-avg_range_person)
    
    avg_range_power = (Indivisual::Power::MU_RANGE.last - Indivisual::Power::MU_RANGE.first) / 2
    mu_power = avg_range_power + (power-avg_range_power)

    avg_range_reach = (Indivisual::Reach::MU_RANGE.last - Indivisual::Reach::MU_RANGE.first) / 2
    mu_reach = avg_range_reach + (reach-avg_range_reach)

    avg_range_gravity = (Indivisual::Gravity::MU_RANGE.last - Indivisual::Gravity::MU_RANGE.first) / 2
    mu_gravity = avg_range_gravity + (gravity-avg_range_gravity)

    avg_range_mt = (Indivisual::MaxTerritory::MU_RANGE.last - Indivisual::MaxTerritory::MU_RANGE.first) / 2
    mu_mt = avg_range_mt + (max_territory-avg_range_mt)

    avg_range_life = (Indivisual::Life::MU_RANGE.last - Indivisual::Life::MU_RANGE.first) / 2
    mu_life = avg_range_life + (life-avg_range_life)

    self.class.new(
      RandomBell.new(mu: mu_person, sigma: SIGMA, range: Indivisual::Personality::MU_RANGE).rand,
      RandomBell.new(mu: mu_power, sigma: SIGMA, range: Indivisual::Power::MU_RANGE).rand,
      RandomBell.new(mu: mu_reach, sigma: SIGMA, range: Indivisual::Reach::MU_RANGE).rand,
      RandomBell.new(mu: mu_gravity, sigma: SIGMA, range: Indivisual::Gravity::MU_RANGE).rand,
      RandomBell.new(mu: mu_mt, sigma: SIGMA, range: Indivisual::MaxTerritory::MU_RANGE).rand,
      RandomBell.new(mu: mu_life, sigma: SIGMA, range: Indivisual::Life::MU_RANGE).rand
    )
  end
end
