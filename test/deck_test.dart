// Import the test package and Counter class
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:handandfoot/deck.dart';
import 'package:collection/collection.dart';

void main() {
  group('Deck Creation', () {
    int numberOfCardsInDeck = 52;
    test('Deck should have 52 unique cards', () {
      var deck = Deck();
      expect(deck.cards.length, numberOfCardsInDeck);
    });

    test('Deck should have 52 unique cards and 2 jokers', () {
      int numberOfJokers = 2;
      var deck = Deck(numberOfJokers: numberOfJokers);
      expect(deck.cards.length, numberOfCardsInDeck + numberOfJokers);
      var actualNumberOfJokers = deck.cards.where((card) => card.rank == Rank.joker).length;
      expect(actualNumberOfJokers, numberOfJokers);
    });
  });

  group('Deck Actions', () {
    test('Shuffle', () {
      var deck = Deck();
      var originalOrder = List.of(deck.cards);
      deck.shuffle();
      var newOrder = List.of(deck.cards);
      expect(false, listEquals(originalOrder, newOrder));

      deck = Deck();
      deck.shuffle();
      var secondOrder = List.of(deck.cards);
      expect(false, listEquals(newOrder, secondOrder));
    });

    test ("Deal", () {
      var deck = Deck();
      var totalCardAmount = deck.cards.length;
      int handSize = 5;
      var hand = deck.deal(handSize);
      expect(handSize, hand.length);
      expect(totalCardAmount - handSize, deck.cards.length);
    });
  });
}