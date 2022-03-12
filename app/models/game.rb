class Game < ApplicationRecord
  belongs_to :player
  belongs_to :dealer
  belongs_to :deck

  #Start the Game
  def self.run
    prompt = TTY::Prompt.new
    puts ""
    puts ""
    puts "Welcome to BlackJack!"
    puts ""
    result = prompt.yes?("Would You Like To Start New Game?")
    return result
  end

  def self.createGame
    #Fetch the only Player
    player1 = Player.first
    #Fetch the only Dealer
    dealer1 = Dealer.first
    #Fetch the only Deck
    deck1 = Deck.first
    currentGame = Game.create(result: "In Progress", deck_id: deck1.id, player_id: player1.id, dealer_id: dealer1.id)
    return currentGame
  end

  # Provide Greeting Before Game Begins
  def provideGreetting
    puts ""
    puts "#{self.dealer.name}: Hello #{self.player.name}, Welcome to BlackJack!"
    puts "#{self.dealer.name}: I will be your dealer today. Good luck!" 
    puts "#{self.dealer.name}: I will now shuffle the deck, and pass out the cards." 
    puts ""
  end

  #Deal Cards to the player and dealer
  def dealCards(currentDeck)
    playersFirstCard = currentDeck.shift
    playersFirstCardValue = playersFirstCard.card_value
    #If player's first card is an Ace set the value to 11
    if playersFirstCardValue == 1
      playersFirstCardValue = 11
    end
    dealersFirstCard = currentDeck.shift 
    dealersFirstCardValue = dealersFirstCard.card_value
    #If dealer's first card is an Ace set the value to 11
    if dealersFirstCardValue == 1
      dealersFirstCardValue = 11
    end
    playersSecondCard = currentDeck.shift
    puts "#{self.dealer.name}: Your first card is a #{playersFirstCard.card_name}."
    puts "#{self.dealer.name}: My first card is a #{dealersFirstCard.card_name}." 
    puts "#{self.dealer.name}: Your second card is a #{playersSecondCard.card_name}." 
    puts ""
    puts "Current Score:"
    playersCurrentScore = playersFirstCardValue + playersSecondCard.card_value
    puts "#{self.player.name}: #{playersCurrentScore}"
    puts "#{self.dealer.name}: #{dealersFirstCardValue}"
    puts ""
    return currentDeck, playersCurrentScore, dealersFirstCardValue
  end

  # Player continues to play until he or she chooses "Stay" or score is >= 21.
  def hitOrStay(playerScore, currentDeck)
    prompt = TTY::Prompt.new
    playerChoseStay = false
    choices = {"Hit" => 1, "Stay" => 2}
    while playerChoseStay == false 
      playerAction = prompt.select("Would You Like To Hit Or Stay?", choices)
      if playerAction == 2
        playerChoseStay = true
        return playerScore, currentDeck
      elsif playerAction == 1
        nextCard = currentDeck.shift
        updatedPlayerScore = nextCard.card_value + playerScore
        puts ""
        puts "#{self.dealer.name}: You chose hit. Your next card is #{nextCard.card_name}"
        puts "#{self.dealer.name}: You're current score is #{updatedPlayerScore}"
        puts ""
        if updatedPlayerScore >= 21
          return updatedPlayerScore, currentDeck
        end
      end
    end
  end

end
