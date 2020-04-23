import 'package:handandfoot/player.dart';

class Team {
  // a list of players
  List<Player> players;
  // books
  // a flag for if they can go out
  // a flag for if they're melded

  Team(this.players) {
    if (this.players.length != 2) {
      throw("Teams are limited to 2 players");
    }
    this.players.forEach((player) {
      player.team = this;
    });
  }

  /**
   * Add cards to meld
   * void addCardsToMeld(list of cards) {
   *  if the cards can be added to the meld
   *    add the cards to the meld
   * }
   */
}