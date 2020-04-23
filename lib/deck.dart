import 'dart:math';

class Deck {
  List<Card> cards;
  List<Suit> get _mainSuits => Suit.values.where((suit) => suit != Suit.none).toList();
  List<Rank> get _mainRank => Rank.values.where((rank) => rank != Rank.joker).toList();

  Deck({int numberOfJokers = 0}) {
    cards = _generateFullDeck(numberOfJokers: numberOfJokers);
  }

  void shuffle() {
    cards.shuffle(Random(0));
  }

  List<Card> deal(int handSize) {
    var hand = cards.sublist(0, handSize);
    cards = cards.sublist(handSize);
    return hand;
  }

  List<Card> _generateFullDeck({int numberOfJokers = 0}) {
    var cards = List<Card>();
    _mainSuits.forEach((suit) {
      _mainRank.forEach((rank) {
        cards.add(Card(suit, rank));
      });
    });
    for(var i = 0; i < numberOfJokers; i++) {
      cards.add(Card(Suit.none, Rank.joker));
    }
    return cards;
  }

}

class Card {
  Suit suit;
  Rank rank;

  Card(this.suit, this.rank);
}

enum Suit {
  none,
  diamonds,
  hearts,
  clubs,
  spades
}

enum Rank {
  joker,
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king
}