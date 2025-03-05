import 'package:equatable/equatable.dart';
import 'nav_drawer_state.dart';

/// Event class for handling navigation events in the drawer
sealed class NavDrawerEvent extends Equatable {
  const NavDrawerEvent();

  @override
  List<Object?> get props => [];
}

class NavigateTo extends NavDrawerEvent {
  final NavItem destination;

  const NavigateTo(this.destination);
//sfgdfgfdfeee
  @override
  List<Object?> get props => [destination];
}
