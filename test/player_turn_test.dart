// Import the test package and Counter class
import 'package:handandfoot/models/game_controller.dart';
import 'package:handandfoot/models/player.dart';
import 'package:handandfoot/models/player_turn.dart';
import 'package:handandfoot/models/team.dart';
import 'package:test/test.dart';
import 'package:handandfoot/models/deck.dart';

void main() {
  group('Player Turn', () {
    Player player = Player("Abe");
    Player player2 = Player("Bob");
    Player player3 = Player("Xander");
    Player player4 = Player("Zach");
    Team team = Team([player, player2]);
    Team team2 = Team([player3, player4]);

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
      var gameController = GameController([team, team2]);
      gameController.gameWillStart();
      gameController.startGame();

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

      controller.currentState = TurnState.playing;
      controller.undoAllMoves();
      expect(controller.currentHand, player.hand);
      expect(controller.currentFoot, player.foot);
      expect(controller.meldedCards.isEmpty, true);
      controller.player.team.books.forEach((rank, meld) {
        expect(meld.isEmpty, true);
      });
    });

    test("After picking up foot, undo leaves all cards prior to picking up",
        () {
      var gameController = GameController([team, team2]);
      gameController.gameWillStart();
      gameController.startGame();
      player.team.willStartANewRound();

      Deck deck = Deck();
      player.hand = deck.deal(11);
      player.foot = deck.deal(11);

      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);
      controller.currentState = TurnState.playing;

      controller.addStockCardsToHand([]);
      player.hand.forEach((card) {
        if (card.rank == Rank.joker ||
            card.rank == Rank.two ||
            card.rank == Rank.three) {
          return;
        }
        controller.addCardsToMeld([card], card.rank);
      });

      controller.currentHand = [];
      controller.playerWillPickUpFoot();

      controller.undoAllMoves();
      expect(controller.currentHand, player.hand);
      expect(controller.currentHand.isEmpty, true);
      expect(controller.currentFoot, player.foot);
      expect(controller.meldedCards.isEmpty, true);
      controller.player.team.books.removeWhere((rank, cards) {
        return cards.isEmpty;
      });

      expect(controller.player.team.books.length > 0, true);
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
      //make a team and instantiate the round on the team to ensure the team has all the objects that it needs
      player.team = team;
      team.willStartANewRound();

      //Get a deck with 3 5's to meld
      while (player.hand.where((card) {
            return card.rank == Rank.five;
          }).length <=
          3) {
        Deck deck = Deck();
        player.hand = deck.deal(52);
        player.foot = deck.deal(0);
      }

      //create a new player turn
      PlayerTurnController controller = PlayerTurnController(player);
      controller.addStockCardsToHand([]);

      //meld the 5's
      List<Card> fives = player.hand.where((card) {
        return card.rank == Rank.five;
      }).toList();
      controller.addCardsToMeld(fives, Rank.five);

      //expect the team to have a meld of 5's
      expect(player.team.books[Rank.five].length, fives.length);

      //expect the controller to keep a record of the cards that are melded
      expect(controller.meldedCards.length, fives.length);
    });
  });
}
