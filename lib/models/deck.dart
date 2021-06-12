import 'dart:math';

class Deck {
  List<Card> cards;
  List<Suit> get _mainSuits =>
      Suit.values.where((suit) => suit != Suit.none).toList();
  List<Rank> get _mainRank =>
      Rank.values.where((rank) => rank != Rank.joker).toList();

  Deck({int numberOfJokers = 0}) {
    cards = _generateFullDeck(numberOfJokers: numberOfJokers);
  }

  static Deck empty() {
    Deck deck = Deck();
    deck.cards = [];
    return deck;
  }

  List<Card> _generateFullDeck({int numberOfJokers = 0}) {
    var cards = <Card>[];
    _mainSuits.forEach((suit) {
      _mainRank.forEach((rank) {
        cards.add(Card(suit, rank));
      });
    });
    for (var i = 0; i < numberOfJokers; i++) {
      cards.add(Card(Suit.none, Rank.joker));
    }
    return cards;
  }

  void shuffle() {
    cards.shuffle();
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

  void add(Card card, {int index = 0}) {
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

  String imagePath() {
    const path = "assets/cards/";
    if (this.rank == Rank.joker) {
      return path + "red_joker.png";
    }
    return path + this.rank.value() + "_" + this.suit.value() + ".png";
  }

  CardColor color() {
    switch (this.suit) {
      case Suit.diamond:
      case Suit.heart:
        return CardColor.red;
        break;
      case Suit.club:
      case Suit.spade:
        return CardColor.black;
        break;
      default:
        return CardColor.none;
    }
  }
}

enum CardColor { black, red, none }

enum Suit { diamond, club, heart, spade, none }

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

extension RankExtension on Rank {
  String value() {
    switch (this) {
      case Rank.joker:
        return "joker";
      case Rank.ace:
        return "1";
      case Rank.two:
        return "2";
      case Rank.three:
        return "3";
      case Rank.four:
        return "4";
      case Rank.five:
        return "5";
      case Rank.six:
        return "6";
      case Rank.seven:
        return "7";
      case Rank.eight:
        return "8";
      case Rank.nine:
        return "9";
      case Rank.ten:
        return "10";
      case Rank.jack:
        return "jack";
      case Rank.queen:
        return "queen";
      case Rank.king:
        return "king";
    }
  }
}

extension SuitExtension on Suit {
  String value() {
    switch (this) {
      case Suit.none:
        return "none";
      case Suit.diamond:
        return "diamond";
      case Suit.heart:
        return "heart";
      case Suit.club:
        return "club";
      case Suit.spade:
        return "spade";
    }
  }
}
