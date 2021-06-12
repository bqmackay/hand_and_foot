import 'dart:ui';

class Round {
  // the index of this round
  int roundIndex;
  // list of team rounds

  // points required to meld
  int pointsToMeld;

  Round(this.roundIndex) {
    switch (this.roundIndex) {
      case 0:
        pointsToMeld = 50;
        break;
      case 1:
        pointsToMeld = 90;
        break;
      case 2:
        pointsToMeld = 120;
        break;
      case 3:
        pointsToMeld = 150;
        break;
      default:
        throw("Only 4 rounds are allowed in Hand and Foot");
    }
  }


}

class TeamRound {
  //team id
  //points
}