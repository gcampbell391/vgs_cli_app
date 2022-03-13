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

  # Provide Greeting 
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

  # Provide Farewell 
  def self.provideFarewell
    puts ""
    puts "That's too bad!"
    sleep(1)
    puts "Maybe next time!"
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
    #Ask player if they want to choose 1 or 11 for their Ace if first card has value < 9
    if playersFirstCardValue < 11 && playersSecondCard.card_value == 1
    choices = {"1" => 1, "11" => 2}
    prompt = TTY::Prompt.new
    aceCardValue = prompt.select("Your second card is an Ace, would should the value be?", choices)
      if aceCardValue == 2
        playersSecondCard.card_value = 11
      end
    end 
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
      playerAction = prompt.select("Would You Like to Hit or Stay?", choices)
      if playerAction == 2
        playerChoseStay = true
        return updatedPlayerScore, currentDeck
      elsif playerAction == 1
        nextCard = currentDeck.shift
        # Ask player if they want Ace to be 1 or 11 if score is <= 10. Dealer might need the same logic. Maybe add logic to 2nd card too
        if nextCard.card_value == 1 && updatedPlayerScore < 11 
          #Ask player if they want to choose 1 or 11
          choices = {"1" => 1, "11" => 2}
          aceCardValue = prompt.select("Your next card is an Ace, would should the value be?", choices)
          if aceCardValue == 2
            nextCard.card_value = 11
          end
        end
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

  # Dealer's turn. Could be refactored.
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
      dealerDrewAce = false
      dealersNextCard = currentDeck.shift
      if updatedDealerScore < 11 && dealersNextCard.card_value == 1
        dealersNextCard.card_value = 11
        dealerDrewAce = true
      end
      updatedDealerScore = updatedDealerScore+ dealersNextCard.card_value
      puts "#{self.dealer.name}: I am going to hit."
      sleep(1)
      puts "#{self.dealer.name}: My next card is a #{dealersNextCard.card_name}"
      sleep(1)
      if dealerDrewAce == true
        puts "#{self.dealer.name}: Since my score is currently low, so I will choose the value 11 instead or 1 for the Ace."
        sleep(1) 
      end
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
      puts "#{self.dealer.name}: It's my lucky day! I hit BlackJack!"
      sleep(1)
      puts "#{self.dealer.name}: Tough break #{self.player.name}. Maybe next time."
      puts ""
      self.result = "Dealer hit BlackJack! Dealer won."
      self.save
      exit
    # Check if dealer busted
    elsif updatedDealerScore > 21
      sleep(1)
      puts "#{self.dealer.name}: Ah snap. I busted..."
      sleep(1)
      puts "#{self.dealer.name}: You win this time, but I shall win next time!"
      puts ""
      self.result = "Dealer busted. Player won."
      self.save
      exit
    # Check if dealer scored at least 17. Dealer only hits if score is below 17.
    elsif updatedDealerScore >= 17
      if updatedDealerScore == playerScore
        sleep(1)
        puts "#{self.dealer.name}: I'm staying at #{updatedDealerScore}. Looks like we tie!"
        sleep(1)
        puts "#{self.dealer.name}: You thought you were going to win with #{playerScore}, didn't you?"
        puts ""
        self.result = "Dealer stayed at #{updatedDealerScore}, and Player stayed at #{playerScore}. Game was tied."
        self.save
      # Check if dealer's score is less than players score after both players stayed
      elsif updatedDealerScore < playerScore
        sleep(1)
        puts "#{self.dealer.name}: I'm staying at #{updatedDealerScore}. Looks like you win."
        sleep(1)
        puts "#{self.dealer.name}: Are you counting cards? I'm on to you :)"
        puts ""
        self.result = "Dealer stayed at #{updatedDealerScore}, and Player stayed at #{playerScore}. Player won."
        self.save
      # Check if dealer's score is more than players score after both players stayed
      elsif updatedDealerScore > playerScore
        sleep(1)
        puts "#{self.dealer.name}: I'm staying at #{updatedDealerScore}. Looks like I win!"
        sleep(1)
        puts "#{self.dealer.name}: Try being more aggresive next time!"
        puts ""
        self.result = "Dealer stayed at #{updatedDealerScore}, And player stayed at #{playerScore}. Dealer won."
        self.save
      end
      exit
    end
  end

  # Check for blackjack or bust..maybe refactor to include dealer
  def checkForBlackJackOrBust(currentScore)
    if currentScore == 21
      sleep(1)
      puts "#{self.dealer.name}: You hit BlackJack! Congratulations! You win!"
      sleep(1)
      puts "#{self.dealer.name}: Please come back and play again!"
      puts ""
      self.result = "Player hit BlackJack! Player won."
      self.save
      exit
    elsif currentScore > 21
        sleep(1)
        puts "#{self.dealer.name}: I'm sorry, but it looks like you busted! I am victorious!"
        sleep(1)
        puts "#{self.dealer.name}: Better luck next time, and thanks for playing!"
        puts ""
        self.result = "Player busted. Dealer won."
        self.save
        exit
    end 
  end

end
