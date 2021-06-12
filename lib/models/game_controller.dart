import './player.dart';
import './player_turn.dart';
import './round.dart';
import './scorer.dart';
import './team.dart';

import 'deck.dart';

class GameController {
//  Stock
  Deck stock;

//  Discard Pile
  Deck discardPile = Deck.empty();

//  Teams
  List<Team> teams;

//  Order of player's turns
  List<Player> playerOrder;

//  Current player
  PlayerTurnController currentPlayerTurn;

  //Current player turn count
  int _currentPlayerIndex = -1;

//  Rounds
  List<Round> rounds;

//  Current Round
  Round currentRound;

//  View

  GameController(this.teams);

  // ignore: slash_for_doc_comments
  /** Performs any function that is required to start the game
   * public startGame {
   *   Build the deck
   *   Select the order of teams
   *   Start a new round
   * }
  **/
  void gameWillStart() {
    //Build the deck
    this._buildDeck();

    //Select the order of teams
    this._setOrderOfPlayers();

    //build the list of rounds
    this._buildRounds();
  }

  void _buildDeck() {
    this.stock = Deck(numberOfJokers: 2);
    teams.forEach((team) {
      //One for each player
      this.stock.cards.addAll(Deck(numberOfJokers: 2).cards);
      this.stock.cards.addAll(Deck(numberOfJokers: 2).cards);
    });
  }

  /// Creates the turn order for players
  /// private create order of players {
  ///    cycle through each team and get their players
  ///      place each team player in the order apart from their other team player by the number of teams in the game
  ///    set order of players to local variable for future reference
  /// }
  void _setOrderOfPlayers() {
    playerOrder = List.filled(teams.length * 2, null);
    //cycle through each team and get their players
    teams.asMap().forEach((i, team) {
      //place each team player in the order apart from their other team player by the number of teams in the game
      playerOrder[i] = team.players.first;
      playerOrder[i + teams.length] = team.players.last;
    });
  }

  void startGame() {
    //Start a new round
    startNextRound();
  }

  /// Begins a new round
  /// public startRound() {
  ///    initiate the current round
  ///    add round to the list of rounds
  ///    deal cards
  ///    flip card from stock
  ///    start next player's turn
  /// }
  void startNextRound() {
    //initiate the current round
    if (this.currentRound == null) {
      this.currentRound = this.rounds[0];
    } else {
      this.currentRound = this.rounds[this.currentRound.roundIndex + 1];
    }
    //inform each team that the next round will start.
    this._prepareTeamsForNewRound();

    //deal cards
    _dealCards();
    //flip card from stock
    this.flipCardFromStockToDiscardPile();

    //start next player's turn
    this.startNextPlayerTurn();
  }

  /// Turns the top card from stock over and onto the discard pile. It also determines if the card is allowed to be on the discard pile
  /// private flip card from stock {
  ///    flip top card off the top of the stock
  ///    if the card flipped needs to be reshuffled
  ///      randomly place the card back in the stock
  ///      flip card again
  /// }
  void flipCardFromStockToDiscardPile() {
//    *    flip top card off the top of the stock
    Card card = this.stock.draw();
    //reshuffle discard pile if stock is empty
    if (card == null) {
      return;
    }
    //if the card flipped needs to be reshuffled
    if (card.rank == Rank.two ||
        card.rank == Rank.joker ||
        (card.rank == Rank.three && card.color() == CardColor.red)) {
      //randomly place the card back in the stock
      this.stock.randomlyInsertCard(card);
      //flip card again
      flipCardFromStockToDiscardPile();
    } else {
      this.discardPile.add(card);
    }
  }

  /// Starts the next players turn
  /// public start next player {
  ///    set the current player to the next player
  /// }
  void startNextPlayerTurn() {
    //set the current player to the next player
    _currentPlayerIndex++;
    this.currentPlayerTurn = PlayerTurnController(
        playerOrder[_currentPlayerIndex % playerOrder.length]);

    //Hand the players turn to the view to tell which player's turn it is
    //view.updatePlayersTurn(this.currentPlayerTurn)
  }

  /// A player draws the top two cards from stock
  /// public draw from stock {
  ///    get top two cards
  ///    give them to the current player
  /// }
  void drawFromStock(Player player) {
    currentPlayerTurn.addStockCardsToHand(stock.deal(2));
  }

  /// A player draws from the discard pile. This must be accompanied by a check that they are allowed to pick up from the discard pile.
  /// public draw from discard pile {
  ///    check if player can pick up from the discard pile
  ///      if so, give them the top card and the other 6 separately
  ///    otherwise
  ///      send the player a message that they can't
  /// }
  void drawFromDiscardIfAble(Player player) {
    //check if player can pick up from the discard pile
    if (!_playerCanDrawFromDiscardPile()) {
      throw "Player cannot draw from discard pile";
    }

    //if so, give them the top card and the other 6 separately
    currentPlayerTurn.addDiscardCardsToHand(discardPile.deal(7));
  }

  bool _playerCanDrawFromDiscardPile() {
    Card topCard = discardPile.cards.last;

    //get hand or foot (whichever the player is currently in)
    List<Card> playersCards = currentPlayerTurn.currentHand;
    if (playersCards.isEmpty) {
      playersCards = currentPlayerTurn.currentFoot;
    }

    //get the book from the team to see if it exists
    var book = currentPlayerTurn.player.team.books[topCard.rank];

    bool playerHasSufficientCardsInHand = playersCards
            .where((card) =>
                card.rank == topCard.rank ||
                card.rank == Rank.two ||
                card.rank == Rank.joker)
            .toList()
            .length >
        1;
    bool bookAlreadyExists = book.length > 2;
    return playerHasSufficientCardsInHand || bookAlreadyExists;
  }

  /// End the current players turn
  /// void end current turn {
  ///  if the current player's team is melded
  ///    send the current player's moves to the rest of the table
  ///    start the next player's turn
  /// }
  void endCurrentPlayerTurn() {
//    if the current player's team is melded
    var currentTeam = this.currentPlayerTurn.player.team;
    var scorer = Scorer();
    if (scorer.calculateTeamBooks(currentTeam) < currentRound.pointsToMeld) {
      throw ("Needs more points or undo their moves");
    }
  }

  /// At the end of the player's turn, the turn is revealed to all the other players.
  /// public show players turn {
  ///    send all melds from the hand to the board for display
  ///    send picking up foot to the board for display
  ///    send all melds from the foot to the board for display
  ///    if the player discarded
  ///      send the discard to the board for display
  ///
  ///    if the player is out of cards
  ///      end the round
  ///    otherwise
  ///      start next player's turn
  /// }
  void sendPlayerTurnToTable(Player player) {}

  /// Perform any action that occurs at the end of the round
  /// private end round {
  ///    tell the scorer to tally scores
  ///    display scores to each player
  ///    listen for all players to be ready for the next round
  /// }
  void endRound() {}

  /// Inform the game that a player is ready for the next round. When all players acknowledge this, the round will start.
  /// public player is ready for next round {
  ///    mark that the player is ready for the next round
  ///
  ///    if all players are ready
  ///      shift the player order by one
  ///      put all cards back into stock
  ///      start next round
  ///    else
  ///      let all other players know the count of players ready to go
  /// }
  void playerIsReadyForNextRound(Player player) {}

  void _buildRounds() {
    this.rounds = List.filled(4, null);
    for (var i = 0; i < this.rounds.length; i++) {
      this.rounds[i] = Round(i);
    }
  }

  void _dealCards() {
    this.stock.shuffle();
    this.teams.forEach((team) {
      team.players.forEach((player) {
        player.hand = this.stock.deal(11);
        player.foot = this.stock.deal(11);
      });
    });
  }

  //inform each team that a new round will start. This should also prepare each player.
  void _prepareTeamsForNewRound() {
    teams.forEach((team) {
      team.willStartANewRound();
    });
  }
}
