// Import the test package and Counter class
import 'package:flutter/foundation.dart';
import 'package:handandfoot/player.dart';
import 'package:handandfoot/player_turn.dart';
import 'package:test/test.dart';
import 'package:handandfoot/deck.dart';
import 'package:collection/collection.dart';

void main() {
  group('Player Turn', ()
  {
    Player player = Player("Abe");


    test("Check initial turn's state", () {
      Deck deck = Deck();
      player.hand = deck.deal(11);
      player.foot = deck.deal(11);

      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);
      //expect the player-turn's cards match that which is in the player's hand and foot
      expect(controller.currentHand, player.hand);
      expect(controller.currentFoot, player.foot);

      //expect the player to be in their hand
      expect(controller.isInFoot(), false);

      //expect the state to be pickup
      expect(controller.currentState, TurnState.pickup);
    });

    test("Copy hand and foot, and undo", () {
      Deck deck = Deck();
      player.hand = deck.deal(11);
      player.foot = deck.deal(11);
      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);

      //ensure that the turn's hand and foot is a copy and not a reference to the player's hand and foot
      controller.currentHand.removeLast();
      controller.currentFoot.removeLast();
      expect(controller.currentHand.length, 10);
      expect(controller.currentFoot.length, 10);
      expect(controller.currentHand != player.hand, true);
      expect(controller.currentFoot != player.foot, true);

      controller.undoAllMoves();
      expect(controller.currentHand, player.hand);
      expect(controller.currentFoot, player.foot);

      //TODO Need to check that the team's melds are reset too
    });

    test("draw from stock", () {
      Deck deck = Deck();
      player.hand = deck.deal(11);
      player.foot = deck.deal(11);

      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);

      //draw from stock
      controller.addStockCardsToHand(deck.deal(2));

      //expect the cards to be added to the player's hand (not the foot)
      expect(player.hand.length, 13);
      expect(player.foot.length, 11);

      //expect the cards to be added to hand (not the foot)
      expect(controller.currentHand.length, 13);
      expect(controller.currentFoot.length, 11);

      //expect the state of the turn to be playing
      expect(controller.currentState, TurnState.playing);
    });

    test("draw from discard", () {
      Deck deck = Deck();
      player.hand = deck.deal(11);
      player.foot = deck.deal(11);

      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);

      //draw from stock
      controller.addDiscardCardsToHand(deck.deal(7));

      //expect the cards to be added to the player's hand (not the foot)
      expect(player.hand.length, 18);
      expect(player.foot.length, 11);

      //expect the cards to be added to hand (not the foot)
      expect(controller.currentHand.length, 18);
      expect(controller.currentFoot.length, 11);

      //expect that 6 cards are marked as unusable
      expect(controller.unusableCards.length, 6);

      //expect the state of the turn to be playing
      expect(controller.currentState, TurnState.playing);
    });

    test("drawing cards when you are in your foot", () {
      Deck deck = Deck();
      player.hand = deck.deal(0);
      player.foot = deck.deal(11);

      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);

      //expect the player to be in their hand
      expect(controller.isInFoot(), true);
    });

    test("meld cards", () {
      //Get a deck with 3 5's to meld
      while (player.hand.where((card) {
        return card.rank == Rank.five;
      }).length <= 3) {
        Deck deck = Deck();
        player.hand = deck.deal(52);
        player.foot = deck.deal(0);
      }

      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);

      //TODO add player's team to this test so it works

      //meld the 5's
      List<Card> fives = player.hand.where((card) { return card.rank == Rank.five; }).toList();
      controller.addCardsToMeld(fives);

      //expect the team to have a meld of 5's
      expect(player.team.books[Rank.five].length, fives.length);

      //expect the controller to keep a record of the cards that are melded
      expect(controller.meldedCards.length, fives.length);

    });
  });
}