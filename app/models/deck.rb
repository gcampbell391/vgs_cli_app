class Deck < ApplicationRecord
    has_many :games 
    has_many :cards

    # Prepares the deck by feteching the cards and shuffling
    def prepareDeck
        preparedDeck = []
        allCards = self.cards.all
        #Shuffle the cards
        preparedDeck = allCards.shuffle
        #Return the prepared deck
        return preparedDeck
    end

end
