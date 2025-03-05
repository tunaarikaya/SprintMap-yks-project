import 'package:equatable/equatable.dart';

enum NavItem {
  homeView,
  todoView,
  questionsView,
  aiView,
  goalsView,
  statisticsView,
  resultsView,
  librariesView,
  badgesView,
  counterView,
  settingsView
}

class NavDrawerState extends Equatable {
  final NavItem selectedItem;

  const NavDrawerState(this.selectedItem);

  @override
  List<Object?> get props => [selectedItem];
}
