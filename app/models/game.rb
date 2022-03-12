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

  # Create a new game
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
    sleep(1)
    puts "#{self.dealer.name}: I will be your dealer today. Good luck!" 
    sleep(1)
    puts "#{self.dealer.name}: I will now shuffle the deck, and pass out the cards." 
    sleep(1)
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
    sleep(1)
    puts "#{self.dealer.name}: My first card is a #{dealersFirstCard.card_name}." 
    sleep(1)
    puts "#{self.dealer.name}: Your second card is a #{playersSecondCard.card_name}." 
    sleep(1)
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
    updatedPlayerScore = playerScore
    while playerChoseStay == false 
      playerAction = prompt.select("Would You Like To Hit Or Stay?", choices)
      if playerAction == 2
        playerChoseStay = true
        return updatedPlayerScore, currentDeck
      elsif playerAction == 1
        nextCard = currentDeck.shift
        # TO-DO: Add prompt to ask user if they want Ace to be 1 or 11 if score is <= 10. Dealer might need the same logic
        updatedPlayerScore = nextCard.card_value + updatedPlayerScore
        puts ""
        puts "#{self.dealer.name}: You chose hit. Your next card is #{nextCard.card_name}"
        sleep(1)
        puts "#{self.dealer.name}: Your current score is #{updatedPlayerScore}"
        puts ""
        if updatedPlayerScore >= 21
          return updatedPlayerScore, currentDeck
        end
      end
    end
  end

  # Dealer's turn. 
  def dealersTurn(playerScore, dealerScore, currentDeck)
    puts ""
    puts "Current Score:"
    puts "#{self.player.name}: #{playerScore}"
    puts "#{self.dealer.name}: #{dealerScore}"
    puts ""
    #Reveal dealer's second card.
    sleep(1)
    puts "#{self.dealer.name}: I will now reveal my second card."
    sleep(1)
    dealersSecondCard = currentDeck.shift
    updatedDealerScore = dealerScore + dealersSecondCard.card_value
    puts "#{self.dealer.name}: My second card is a #{dealersSecondCard.card_name}"
    sleep(1)
    puts "#{self.dealer.name}: My current score is #{updatedDealerScore}"
    sleep(1)
    puts ""
    
    # Dealer will continue to hit until score is > 17
    while updatedDealerScore < 17 
      dealersNextCard = currentDeck.shift
      updatedDealerScore = updatedDealerScore+ dealersNextCard.card_value
      puts "#{self.dealer.name}: I Am Going To Hit."
      sleep(2)
      puts "#{self.dealer.name}: My next card is a #{dealersNextCard.card_name}"
      sleep(1)
      puts "#{self.dealer.name}: My current score is #{updatedDealerScore}"
      sleep(1)
      puts ""
      puts "Current Score:"
      puts "#{self.player.name}: #{playerScore}"
      puts "#{self.dealer.name}: #{updatedDealerScore}"
      puts ""
      sleep(1)
    end
    # Check if dealer has blackjack
    if updatedDealerScore == 21
      sleep(1)
      puts "#{self.dealer.name}: It's My Lucky Day! I Hit BlackJack!"
      sleep(1)
      puts "#{self.dealer.name}: Tough break #{self.player.name}. Maybe Next Time."
      puts ""
      self.result = "Dealer Hit BlackJack! Dealer Won."
      self.save
      exit
    # Check if dealer busted
    elsif updatedDealerScore > 21
      sleep(1)
      puts "#{self.dealer.name}: Ah Snap. I Busted.."
      sleep(1)
      puts "#{self.dealer.name}: You Win This Time, But I Shall Win Next Time!"
      puts ""
      self.result = "Dealer Busted. Player Won."
      self.save
      exit
    # Check if dealer scored at least 17. Dealer only hits if score is below 17.
    elsif updatedDealerScore >= 17
      if updatedDealerScore == playerScore
        sleep(1)
        puts "#{self.dealer.name}: I'm Staying at #{updatedDealerScore}. Looks Like We Tie!"
        sleep(1)
        puts "#{self.dealer.name}: You Thought You Were Going To Win With #{playerScore} Didn't You?"
        puts ""
        self.result = "Dealer Stayed At #{updatedDealerScore}, And Player Stayed At #{playerScore}. Game Was Tied."
        self.save
      # Check if dealer's score is less than players score after both players stayed
      elsif updatedDealerScore < playerScore
        sleep(1)
        puts "#{self.dealer.name}: I'm Staying at #{updatedDealerScore}. Looks Like You Win."
        sleep(1)
        puts "#{self.dealer.name}: Are You Counting Cards? I'm On To You :)"
        puts ""
        self.result = "Dealer Stayed At #{updatedDealerScore}, And Player Stayed At #{playerScore}. Player Won."
        self.save
      # Check if dealer's score is more than players score after both players stayed
      elsif updatedDealerScore > playerScore
        sleep(1)
        puts "#{self.dealer.name}: I'm Staying at #{updatedDealerScore}. Looks Like I Win!"
        sleep(1)
        puts "#{self.dealer.name}: Try Being More Aggresive Next Time!"
        puts ""
        self.result = "Dealer Stayed At #{updatedDealerScore}, And Player Stayed At #{playerScore}. Dealer Won."
        self.save
      end
      exit
    end
    
  end

end
