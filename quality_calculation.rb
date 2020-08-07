module QualityCalculation
  class Calculator
    AWARD_NAMES = ['NORMAL ITEM', 'Blue First', 'Blue Distinction Plus', 'Blue Compare', 'Blue Star'].freeze

    def self.refresh(award)
      case award.name
      when AWARD_NAMES[0]
        refresh_normal_item(award)
      when AWARD_NAMES[1]
        refresh_blue_first(award)
      when AWARD_NAMES[3]
        refresh_blue_compare(award)
      when AWARD_NAMES[4]
        refresh_blue_star(award)
      end

      reduce_expiry(award) unless award.name == AWARD_NAMES[2]
    end

    private

    def self.refresh_normal_item(award)
      award.quality -= 1 if award.quality.positive?
      award.quality -= 1 if expired?(award)
    end

    def self.refresh_blue_star(award)
      award.quality -= 2 if award.quality >= 2
      award.quality -= 2 if expired?(award) && award.quality >= 2
    end

    def self.refresh_blue_first(award)
      award.quality += 1 if award.quality < 50
      award.quality += 1 if expired?(award) && award.quality < 50
    end

    def self.refresh_blue_compare(award)
      if expired?(award)
        award.quality = 0
      elsif award.quality < 50
        award.quality += 3 if award.quality <= 47 && award.expires_in <= 5
        award.quality += 2 if award.quality <= 48 && award.expires_in.between?(6, 10)
        award.quality += 1 if award.expires_in > 10
      end
    end

    def self.reduce_expiry(award)
      award.expires_in -= 1
    end

    def self.expired?(award)
      return true if award.expires_in <= 0
    end
  end
end
