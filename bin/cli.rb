require_relative '../config/environment'

# Start the CLI app!
startGame = Game.run
if startGame 
    # Create new game
    currentGame = Game.createGame
    # Provide Greeting
    currentGame.provideGreetting
    # Prepare the game deck 
    cards = currentGame.deck.cards.all
    preparedDeck = Deck.shuffleCards(cards)
    # Deal Cards 
    currentDeck, currentPlayerScore, currentDealerScore = currentGame.dealCards(preparedDeck)
    # Check for BlackJack or Bust
    currentGame.checkForBlackJackOrBust(currentPlayerScore)
    #Ask Player for turn. The Player continues until they select "Stay", hit BlackJack, or bust
    currentPlayerScore, currentDeck = currentGame.hitOrStay(currentPlayerScore, currentDeck)
    # Check for BlackJack or Bust
    currentGame.checkForBlackJackOrBust(currentPlayerScore)
    #Proceed with Dealers turn. Dealer reveals second card, and continues to hit if score is < 17
    currentGame.dealersTurn(currentPlayerScore, currentDealerScore, currentDeck)
else
    # Provide Farewell
    Game.provideFarewell
end





