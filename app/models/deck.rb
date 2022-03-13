class Deck < ApplicationRecord
    has_many :games 
    has_many :cards

    # Prepares the deck by shuffling
    def self.shuffleCards(cards)
        shuffledDeck = []
        #Shuffle the cards
        shuffledDeck = cards.shuffle
        #Return the prepared deck
        return shuffledDeck
    end

end
