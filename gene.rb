require "./indivisual.rb"

class Gene < Struct.new( 
  :personality, 
  :power, 
  :reach, 
  :gravity, 
  :max_territory, 
  :life 
)
  
  autoload :Personality, File.expand_path('../gene/personality', __FILE__) 
  autoload :Power, File.expand_path('../gene/power', __FILE__)
  autoload :Reach, File.expand_path('../gene/reach', __FILE__)
  autoload :Gravity, File.expand_path('../gene/gravity', __FILE__)
  autoload :MaxTerritory, File.expand_path('../gene/max_territory', __FILE__)
  autoload :Life, File.expand_path('../gene/life', __FILE__)

  SIGMA = 0.2
  RANGE = 0.0..5.0

  class << self
    def random
      new( 
        Random.rand( Personality::MU_RANGE ),
        Random.rand( Power::MU_RANGE ),
        Random.rand( Reach::MU_RANGE ),
        Random.rand( Gravity::MU_RANGE ),
        Random.rand( MaxTerritory::MU_RANGE ),
        Random.rand( Life::MU_RANGE )
      )
    end
  end

  # Produce the next generation
  def generate!
    avg_range_person = (Personality::MU_RANGE.last - Personality::MU_RANGE.first) / 2
    mu_person = avg_range_person + (personality-avg_range_person)
    
    avg_range_power = (Power::MU_RANGE.last - Power::MU_RANGE.first) / 2
    mu_power = avg_range_power + (power-avg_range_power)

    avg_range_reach = (Reach::MU_RANGE.last - Reach::MU_RANGE.first) / 2
    mu_reach = avg_range_reach + (reach-avg_range_reach)

    avg_range_gravity = (Gravity::MU_RANGE.last - Gravity::MU_RANGE.first) / 2
    mu_gravity = avg_range_gravity + (gravity-avg_range_gravity)

    avg_range_mt = (MaxTerritory::MU_RANGE.last - MaxTerritory::MU_RANGE.first) / 2
    mu_mt = avg_range_mt + (max_territory-avg_range_mt)

    avg_range_life = (Life::MU_RANGE.last - Life::MU_RANGE.first) / 2
    mu_life = avg_range_life + (life-avg_range_life)

    self.class.new(
      RandomBell.new(mu: mu_person, sigma: SIGMA, range: Personality::MU_RANGE).rand,
      RandomBell.new(mu: mu_power, sigma: SIGMA, range: Power::MU_RANGE).rand,
      RandomBell.new(mu: mu_reach, sigma: SIGMA, range: Reach::MU_RANGE).rand,
      RandomBell.new(mu: mu_gravity, sigma: SIGMA, range: Gravity::MU_RANGE).rand,
      RandomBell.new(mu: mu_mt, sigma: SIGMA, range: MaxTerritory::MU_RANGE).rand,
      RandomBell.new(mu: mu_life, sigma: SIGMA, range: Life::MU_RANGE).rand
    )
  end
end
