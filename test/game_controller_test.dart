import 'package:flutter_test/flutter_test.dart';
import 'package:handandfoot/models/deck.dart';
import 'package:handandfoot/models/game_controller.dart';
import 'package:handandfoot/models/player.dart';
import 'package:handandfoot/models/team.dart';

void main() {
  group('Game Creation', () {
    List<Team> teams = [
      Team([Player("Abe"), Player("Bonny")]),
      Team([Player("Xander"), Player("Zach")])
    ];

    test("Game should have a deck before starting", () {
      var controller = GameController(teams);
      controller.gameWillStart();

      //Check that two full decks + 2 jokers per deck are used
      expect(controller.stock.cards.length, 270,
          reason:
              "Deck should contain the one more full decks than the number as players plus two jokers for each deck");
      //Check that the order of the teams alternate between teams
      expect(controller.playerOrder.map((player) => player.name),
          ["Abe", "Xander", "Bonny", "Zach"]);
      //Check that the list of rounds is set
      expect(controller.rounds.length, 4);
    });

    test("Starting the first round ensures all players are ready", () {
      var controller = GameController(teams);
      controller.gameWillStart();
      controller.startGame();

      //Check that all players have 11 cards in their hand and in their foot
      controller.teams.forEach((team) {
        team.players.forEach((player) {
          expect(player.hand.length, 11);
          expect(player.foot.length, 11);
        });
      });

      //Expect for one card to be in the discard pile
      expect(controller.discardPile.cards.length, 1);
      Card topCard = controller.discardPile.cards.first;
      expect([Rank.two, Rank.joker].contains(topCard.rank), false);
      expect(topCard.rank == Rank.three && topCard.color() == CardColor.red,
          false);

      //Expect card to be reshuffled into deck
      controller.stock.add(Card(Suit.heart, Rank.three));
      controller.flipCardFromStockToDiscardPile();
      topCard = controller.discardPile.cards.first;
      expect([Rank.two, Rank.joker].contains(topCard.rank), false);
      expect(topCard.rank == Rank.three && topCard.color() == CardColor.red,
          false);

      controller.stock.add(Card(Suit.heart, Rank.two));
      controller.flipCardFromStockToDiscardPile();
      topCard = controller.discardPile.cards.first;
      expect([Rank.two, Rank.joker].contains(topCard.rank), false);
      expect(topCard.rank == Rank.three && topCard.color() == CardColor.red,
          false);

      controller.stock.add(Card(Suit.none, Rank.joker));
      controller.flipCardFromStockToDiscardPile();
      topCard = controller.discardPile.cards.first;
      expect([Rank.two, Rank.joker].contains(topCard.rank), false);
      expect(topCard.rank == Rank.three && topCard.color() == CardColor.red,
          false);

      //Test that all teams have 12 empty books
      teams.forEach((team) {
        expect(team.books.length, 11);
        team.books.forEach((rank, cards) {
          expect(cards.length, 0);
        });
      });

      //Check that the current player is set
      expect(controller.currentPlayerTurn != null, true);
    });
  });
}
