import 'package:handandfoot/team.dart';

class Scorer {
  /**
   * calculate team score {
   *  requires a team
   *  requires if the team was the one to go out
   *  calculate the team's books
   *  calculate the team's played cards
   *  calculate the team's unplayed cards
   *  if the team went out, add 100 points
   * }
    */
  void calculateTeamScore(Team team) {

  }

  /**
   * calculate the team's books {
   *  require a team's books
   *  map the team's books to their points
   *    if the book is clean, add 500 points
   *    if the book is dirty, add 300 points
   * }
   */
  num calculateTeamBooks(Team team) {
    return 0;
  }

  /**
   * calculate teh team's played cards {
   *
   * }
   */
  num calculateTeamPlayedCardPoints(Team team) {
    return 0;
  }

  /**
   * calculate teh team's unplayed cards {
   *
   * }
   */
  num calculateTeamUnplayedCardPoints(Team team) {
    return 0;
  }
}