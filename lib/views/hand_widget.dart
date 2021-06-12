import 'package:flutter/material.dart';
import 'package:handandfoot/models/deck.dart' show Deck;
import 'package:handandfoot/models/deck.dart' as HFCard show Card;

class HandWidget extends StatefulWidget {
  HandWidget({Key key}) : super(key: key);

  @override
  _HandWidgetState createState() => _HandWidgetState();
}

class _HandWidgetState extends State<HandWidget> {
  Deck _deck = Deck();
  var _hand = <HFCard.Card>[];
  Set<int> _selectedCardIndexes = Set();

  @override
  void initState() {
    super.initState();
    _deck.shuffle();
    _hand = _deck.deal(10);
  }

  @override
  Widget build(BuildContext context) {
    _hand.sort((card1, card2) {
      var rank = card1.rank.index.compareTo(card2.rank.index);
      if (rank == 0) {
        //same rank
        return card1.suit.index.compareTo(card2.suit.index);
      } else {
        return rank;
      }
    });

    double widthPerCard = 100.0;
    double screenWidth = MediaQuery.of(context).size.width;
    double visibleWidthPerCard = (screenWidth < widthPerCard * _hand.length)
        ? (screenWidth - widthPerCard) / (_hand.length - 1)
        : 60;

    return Center(
      child: Container(
        height: 200,
        width: visibleWidthPerCard * (_hand.length - 1) + widthPerCard,
        color: Colors.blue,
        child: Center(
          child: ListView.builder(
            itemCount: _hand.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _toggleCardSelection(index);
                },
                child: SizedBox(
                  width: (index < _hand.length - 1)
                      ? visibleWidthPerCard
                      : widthPerCard,
                  child: OverflowBox(
                    maxWidth: widthPerCard,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Image(
                        image: AssetImage(_hand[index].imagePath()),
                        alignment: _selectedCardIndexes.contains(index)
                            ? Alignment.topLeft
                            : Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _toggleCardSelection(int index) {
    setState(() {
      if (_selectedCardIndexes.contains(index)) {
        _selectedCardIndexes.remove(index);
      } else {
        _selectedCardIndexes.add(index);
      }
    });
  }
}
