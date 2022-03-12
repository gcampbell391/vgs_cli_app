require_relative '../config/environment'

# Start the CLI app!

startGame = Game.run
if startGame 
    # Create new game
    currentGame = Game.createGame
    # Provide Greeting
    currentGame.provideGreetting
    # Prepare the game deck 
    preparedDeck = currentGame.deck.prepareDeck
    # Deal Cards 
    currentDeck, currentPlayerScore, currentDealerScore = currentGame.dealCards(preparedDeck)
    # Check for BlackJack
    if currentPlayerScore == 21
        puts "#{currentGame.dealer.name}: You Hit BlackJack! Congratulations! You Win!"
        puts "#{currentGame.dealer.name}: Please Come Back And Play Again!"
        puts ""
        currentGame.result = "Player hit BlackJack! Player Won."
        currentGame.save
        exit
    end 
    #Ask Player for turn. The Player continues until they select "Stay", hit BlackJack, or bust
    currentPlayerScore, currentDeck,  = currentGame.hitOrStay(currentPlayerScore, currentDeck)
    # Check for BlackJack or Bust
    if currentPlayerScore == 21
        puts "#{currentGame.dealer.name}: You Hit BlackJack! Congratulations! You Win!"
        puts "#{currentGame.dealer.name}: Please Come Back And Play Again!"
        puts ""
        currentGame.result = "Player hit BlackJack! Player Won."
        currentGame.save
        exit
    elsif currentPlayerScore > 21
        puts "#{currentGame.dealer.name}: I'm Sorry, But It Looks Like You Busted! I am Victorious!"
        puts "#{currentGame.dealer.name}: Better Luck Next Time, and Thanks for Playing!"
        puts ""
        currentGame.result = "Player Busted. Dealer Won."
        currentGame.save
        exit
    end 
    #Proceed with Dealers turn. Dealer reveals second card, and continues to hit if score is < 17
    currentGame.dealersTurn(currentPlayerScore, currentDealerScore, currentDeck)
else
    puts ""
    puts "Maybe Next Time!"
    puts ""
end





