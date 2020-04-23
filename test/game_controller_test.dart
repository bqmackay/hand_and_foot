import 'package:flutter_test/flutter_test.dart';
import 'package:handandfoot/game_controller.dart';
import 'package:handandfoot/player.dart';
import 'package:handandfoot/team.dart';

void main() {
  group('Game Creation', () {
    List<Team> teams = [
      Team(
          [
            Player("Abe"),
            Player("Bonny")
          ]
      ),
      Team(
          [
            Player("Xander"),
            Player("Zach")
          ]
      )
    ];

    test("Game should have a deck before starting", () {
      var controller = GameController(teams);
      controller.gameWillStart();

      //Check that two full decks + 2 jokers per deck are used
      expect(controller.stock.cards.length, 270, reason: "Deck should contain the one more full decks than the number as players plus two jokers for each deck");
      //Check that the order of the teams alternate between teams
      expect(controller.playerOrder.map((player) => player.name), ["Abe", "Xander", "Bonny", "Zach"]);
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

    });

  });
}