module ElectionSafe
    extend ActiveSupport::Concern
  
    PROHIBITED_WORDS = [
      'trump', 'harris', 'democrats', 'democrat',
      'republican', 'republicans', 'biden', 'kamala'
    ].freeze
  
    included do
      validate :no_election_influence
    end
  
    private
  
    def no_election_influence
      return unless body.present?
  
      PROHIBITED_WORDS.each do |word|
        if body.downcase.include?(word)
          errors.add(:body, "contains political content (#{word}). Please avoid discussing election-related topics.")
        end
      end
    end
  end