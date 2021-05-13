import 'dart:math';

class Deck {
  List<Card> cards;
  List<Suit> get _mainSuits => Suit.values.where((suit) => suit != Suit.none).toList();
  List<Rank> get _mainRank => Rank.values.where((rank) => rank != Rank.joker).toList();

  Deck({int numberOfJokers = 0}) {
    cards = _generateFullDeck(numberOfJokers: numberOfJokers);
  }

  static Deck empty() {
    Deck deck = Deck();
    deck.cards = List();
    return deck;
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

  void shuffle() {
    cards.shuffle(Random(0));
  }

  List<Card> deal(int handSize) {
    List<Card> hand;
    if (cards.length < handSize) {
      hand = cards.sublist(0);
    } else {
      hand = cards.sublist(0, handSize);
    }

    cards = cards.sublist(hand.length);
    return hand;
  }

  Card draw() {
    if (this.cards.length > 0) {
      return deal(1).first;
    } else {
      return null;
    }
  }

  void add(Card card, { int index = 0 }) {
    this.cards.insert(index, card);
  }

  void randomlyInsertCard(Card card) {
    cards.insert(Random().nextInt(cards.length), card);
  }
}

class Card {
  Suit suit;
  Rank rank;

  Card(this.suit, this.rank);

  CardColor color() {
    switch (this.suit) {
      case Suit.diamonds:
      case Suit.hearts:
        return CardColor.red;
        break;
      case Suit.clubs:
      case Suit.spades:
        return CardColor.black;
        break;
      default:
        return CardColor.none;
    }
  }
}

enum CardColor {
  black,
  red,
  none
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