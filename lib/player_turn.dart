class PlayerTurn {
  // the player
  // initial hand
  // initial foot
  // current hand
  // current foot
  // the cards played to meld
  // the card discarded
  // a flag for if they went into their foot
  // a flag for if they went out
  // cards drawn
  // unusable cards
  // 3s laid down

  /**
   * receive cards from drawing from stock
   * void addStockCardsToHand(list of cards) {
   *   add the cards to the either the hand or foot (whichever is playable)
   *   Set the player's turn initial hand
   * }
   */

  /**
   * add the remaining cards from the discard pile pickup to the unusable cards for the duration of the turn
   * void addDiscardCardsToHand {
   *  add the cards to the either the hand or foot (whichever is playable)
   *  add the cards to the unusable cards list so we know they can't be used
   *  Set the player's turn initial hand
   * }
   */

  /**
   * Add cards to meld
   * void addCardsToMeld(List of cards) {
   *  if the list of cards are not unusable
   *    move them to the appropriate team book
   *    if the move is invalid
   *      inform the player
   *    otherwise
   *      add the cards to the list of melded cards
   * }
   */

  /**
   * anything that must be done when picking up the foot
   * void playerWillPickUpFoot() {
   *  inform the players current turn that the initial cards are now the foots cards so that an undo only returns them back to their foot
   * }
   */

  /**
   * player's turn will end
   * void playerTurnWillEnd() {
   *  set current hand and foot to the players hand or foot
   *  set if the player is in their foot
   * }
   */

  /**
   * Undo all moves and return the player's cards back to their original state
   * void undoAllMoves() {
   *  inform the team that all cards that have been played to meld are now removed from their melds
   *  set the initial hand to the current hand
   *  get the initial foot to the current foot
   * }
   */
}