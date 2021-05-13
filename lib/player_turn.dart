import 'package:handandfoot/player.dart';

import 'deck.dart';

enum TurnState {
  pickup,
  playing,
  discard
}

class PlayerTurnController {
  // the player
  Player player;

  // current hand
  List<Card> currentHand;

  // current foot
  List<Card> currentFoot;

  //maintain the turn's state: pickup, playing, discard
  TurnState currentState = TurnState.pickup;

  // the cards played to meld
  List<Card> meldedCards = List();
  
  // the card discarded
  Card discardedCard;
  
  // unusable cards
  List<Card> unusableCards = List();

  PlayerTurnController(this.player) {
    this.currentHand = List.from(this.player.hand);
    this.currentFoot = List.from(this.player.foot);
  }

  /// receive cards from drawing from stock
  /// void addStockCardsToHand(list of cards) {
  ///   cancel the function if the state is not pickup
  ///   add the cards to the either the hand or foot (whichever is playable)
  ///   add the cards to the player's hand or foot
  ///   Set the state to playing
  /// }
  void addStockCardsToHand(List<Card> cards) {
    //cancel the function if the state is not pickup
    if (currentState != TurnState.pickup) { return; }
    //add the cards to the either the hand or foot (whichever is playable)
    //add the cards to the player's hand or foot so we know where to undo to
    if (isInFoot()) {
      this.currentFoot.addAll(cards);
      this.player.foot.addAll(cards);
    } else {
      this.currentHand.addAll(cards);
      this.player.hand.addAll(cards);
    }

    //Set the state to playing
    this.currentState = TurnState.playing;
  }


  /// add the remaining cards from the discard pile pickup to the unusable cards for the duration of the turn
  /// void addDiscardCardsToHand {
  ///  cancel the function if the state is not pickup
  ///  add the cards to the either the hand or foot (whichever is playable)
  ///  add the cards to the unusable cards list so we know they can't be used
  ///  Set the player's turn initial hand
  ///   Set the state to playing
  /// }

  void addDiscardCardsToHand(List<Card> cards) {
    //cancel the function if the state is not pickup
    if (currentState != TurnState.pickup) { return; }

    //add the cards to the either the hand or foot (whichever is playable)
    //Set the player's turn initial hand
    //Set the state to playing
    this.addStockCardsToHand(cards);

    //add the cards to the unusable cards list so we know they can't be used
    this.unusableCards = cards.sublist(1);
  }

  /// Add cards to meld
  /// void addCardsToMeld(List of cards) {
  ///  ensure all the cards in the list are of the same rank
  ///  cancel the function if the state is not playing
  ///  if the list of cards are not unusable
  ///    move them to the appropriate team book
  ///    if the move is invalid
  ///      inform the player
  ///    otherwise
  ///      add the cards to the list of melded cards
  /// }
  void addCardsToMeld(List<Card> cards, Rank rank) {
    //ensure all the cards in the list are of the same rank
    if (cards.where((card) => card.rank != rank && card.rank != Rank.two && card.rank != Rank.joker).toList().length > 0) {
      throw "Cards are not a valid rank";
    }
    //cancel the function if the state is not playing
    if (currentState != TurnState.playing) { return; }

    //if the list of cards are not unusable
    List<Card> unusableCardCheckList = List.of(unusableCards);
    unusableCardCheckList.addAll(cards);
    if (unusableCardCheckList.toSet().length != cards.length + unusableCards.length) {
      throw "Unusable cards were attempted to meld";
    }

    //move them to the appropriate team book
    this.player.team.addCardsToMeld(cards, rank);

    //add the cards to the list of melded cards
    this.meldedCards.addAll(cards);
    cards.forEach((card) => this.currentHand.remove(card));
  }

  /// Anything that must be done when picking up the foot
  Future<void> playerWillPickUpFoot() async {
    //cancel the function if the state is not playing
    if (currentState != TurnState.playing) { return; }
    //update the player's hand so that it's empty and can't be undone
    this.player.hand = currentHand;
    //clear the melded cards so they can't be undone
    this.meldedCards = List();

    // TODO: inform the players current turn that the initial cards are now the foots cards so that an undo only returns them back to their foot
  }

  /// player's turn will end
  void playerTurnWillEnd() {
    //set current hand and foot to the players hand or foot
    this.player.hand = this.currentHand;
    this.player.foot = this.currentFoot;

    //set the state to discard
    currentState = TurnState.discard;

  }

  /// Undo all moves and return the player's cards back to their original state.
  /// If the team has already gone to their foot, only return them back to
  /// the state after they picked up their foot.
  void undoAllMoves() {
    ///  cancel if the state is not playing
    if (currentState != TurnState.playing) { return; }

    ///  inform the team that all cards that have been played to meld are now removed from their melds

    ///  set the initial hand to the current hand
    this.currentHand = List.from(this.player.hand);
    ///  get the initial foot to the current foot
    this.currentFoot = List.from(this.player.foot);
    ///  clear the melded cards list
    this.player.team.undoCardsFromMelds(meldedCards);
    meldedCards.clear();
  }

  /// a flag for if they went into their foot
  bool isInFoot() {
    return this.currentHand.length == 0;
  }

  /// a flag for the player went out
  bool didGoOut() {
    return this.currentFoot.length == 0;
  }
}