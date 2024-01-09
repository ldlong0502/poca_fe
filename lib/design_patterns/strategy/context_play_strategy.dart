import 'package:poca/design_patterns/strategy/play_strategy.dart';

class ContextPlayStrategy {
  late PlayStrategy playStrategy;


  void setPlayStrategy(PlayStrategy strategy) {
    playStrategy = strategy;
  }

}