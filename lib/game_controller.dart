

import 'package:flutter/rendering.dart';
import 'package:handandfoot/player.dart';
import 'package:handandfoot/round.dart';
import 'package:handandfoot/team.dart';

import 'deck.dart';

class GameController {

//  Stock
  Deck stock;
//  Discard Pile

//  Teams
  List<Team> teams;

//  Order of player's turns
  List<Player> playerOrder;

//  Current player

//  Rounds
  List<Round> rounds;

//  Current Round
  Round currentRound;

//  View

  GameController(this.teams);

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

  void startGame() {
    //Start a new round
    startNextRound();
  }

  void _buildDeck() {
    this.stock = Deck(numberOfJokers: 2);
    teams.forEach((team) {
      //One for each player
      this.stock.cards.addAll(Deck(numberOfJokers: 2).cards);
      this.stock.cards.addAll(Deck(numberOfJokers: 2).cards);
    });
  }

  /** Creates the turn order for players
   * private create order of players {
   *    cycle through each team and get their players
   *      place each team player in the order apart from their other team player by the number of teams in the game
   *    set order of players to local variable for future reference
   * }
   */
  void _setOrderOfPlayers() {
    playerOrder = List(teams.length * 2);
    //cycle through each team and get their players
    teams.asMap().forEach((i, team) {
      //place each team player in the order apart from their other team player by the number of teams in the game
      playerOrder[i] = team.players.first;
      playerOrder[i + teams.length] = team.players.last;
    });
  }

  /** Begins a new round
   * public startRound() {
   *    initiate the current round
   *    add round to the list of rounds
   *    deal cards
   *    flip card from stock
   *    start next player's turn
   * }
   */
  void startNextRound() {
    //initiate the current round
    if (this.currentRound == null) {
      this.currentRound = this.rounds[0];
    } else {
      this.currentRound = this.rounds[this.currentRound.roundIndex + 1];
    }
    //deal cards
    _dealCards();
    //flip card from stock
    this.flipCardFromStockToDiscardPile();
    //start next player's turn
    this.startNextPlayerTurn();
  }

  /** Turns the top card from stock over and onto the discard pile. It also determines if the card is allowed to be on the discard pile
   * private flip card from stock {
   *    flip top card off the top of the stock
   *    if the card flipped needs to be reshuffled
   *      randomly place the card back in the stock
   *      flip card again
   * }
   */
  void flipCardFromStockToDiscardPile() {

  }

  /** Starts the next players turn
   * public start next player {
   *    set the current player to the next player
   * }
   */
  void startNextPlayerTurn() {

  }

  /** A player draws the top two cards from stock
   * public draw from stock {
   *    get top two cards
   *    give them to the current player
   * }
   */
  void drawFromStock(Player player) {

  }

  /** A player draws from the discard pile. This must be accompanied by a check that they are allowed to pick up from the discard pile.
   * public draw from discard pile {
   *    check if player can pick up from the discard pile
   *      if so, give them the top card and the other 6 separately
   *    otherwise
   *      send the player a message that they can't
   * }
   */
  void drawFromDiscardIfAble(Player player) {

  }

  /**
   * End the current players turn
   * void end current turn {
   *  if the current player's team is melded
   *    send the current player's moves to the rest of the table
   *    start the next player's turn
   * }
   */
  void endCurrentPlayerTurn() {

  }

  /** At the end of the player's turn, the turn is revealed to all the other players.
   * public show players turn {
   *    send all melds from the hand to the board for display
   *    send picking up foot to the board for display
   *    send all melds from the foot to the board for display
   *    if the player discarded
   *      send the discard to the board for display
   *
   *    if the player is out of cards
   *      end the round
   *    otherwise
   *      start next player's turn
   * }
   */
  void sendPlayerTurnToTable(Player player) {

  }

  /** Perform any action that occurs at the end of the round
   * private end round {
   *    tell the scorer to tally scores
   *    display scores to each player
   *    listen for all players to be ready for the next round
   * }
   */
  void endRound() {

  }

  /** Inform the game that a player is ready for the next round. When all players acknowledge this, the round will start.
   * public player is ready for next round {
   *    mark that the player is ready for the next round
   *
   *    if all players are ready
   *      shift the player order by one
   *      put all cards back into stock
   *      start next round
   *    else
   *      let all other players know the count of players ready to go
   * }
   */
  void playerIsReadyForNextRound(Player player) {

  }

  void _buildRounds() {
    this.rounds = List(4);
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

}