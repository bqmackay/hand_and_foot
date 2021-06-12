import './team.dart';

import 'deck.dart';

class Player {
  // Player Name
  String name;
  // their team
  Team team;
  // hand
  List<Card> hand = [];
  // foot
  List<Card> foot = [];
  // is_foot_in_use
  // players current turn

  Player(this.name) {
    if (this.name.isEmpty) {
      throw ("Player name must not be empty");
    }
  }

  /**
   * Add cards to meld
   * void addCardsToMeld(List of cards) {
   *    send cards to the team for melding
   * }
   */

}
