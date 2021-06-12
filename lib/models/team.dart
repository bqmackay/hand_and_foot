import './player.dart';

import 'deck.dart';

class Team {
  // a list of players
  List<Player> players;

  // books
  Map<Rank, List<Card>> books;

  // a flag for if they can go out
  bool canGoOut = false;

  // a flag for if they're melded
  bool isMelded = false;

  Team(this.players) {
    if (this.players.length != 2) {
      throw ("Teams are limited to 2 players");
    }
    this.players.forEach((player) {
      player.team = this;
    });
  }

  /// Prepare the team for a new round
  void willStartANewRound() {
    //clean out the books
    books = Map();
    Rank.values.forEach((rank) {
      //continue if the rank cannot have its own book
      if (![Rank.two, Rank.three, Rank.joker].contains(rank)) {
        books[rank] = [];
      }
    });
    //clean out the player's hands and foots
    this.players.forEach((player) {
      player.hand = [];
      player.foot = [];
    });
  }

  /// Add cards to meld
  /// void addCardsToMeld(list of cards) {
  ///  if the cards can be added to the meld
  ///    add the cards to the meld
  /// }
  void addCardsToMeld(List<Card> cards, Rank rank) {
    books[rank].addAll(cards);
  }

  /// Removes the given cards from the meld
  /// void removeCardsFromMelds(list of cards to remove from melds) {
  ///  Cycle through each book to remove any card in the list of cards given.
  /// }
  void undoCardsFromMelds(List<Card> cards) {
    //Cycle through each book to remove any card in the list of cards given.
    books.forEach((rank, meld) {
      meld.removeWhere((card) {
        return cards.contains(card);
      });
    });
  }
}
