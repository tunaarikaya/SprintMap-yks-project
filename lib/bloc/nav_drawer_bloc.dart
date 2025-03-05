// nav_drawer_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintmap/bloc/drawer_event.dart';
import 'nav_drawer_state.dart';

class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {
  NavDrawerBloc() : super(const NavDrawerState(NavItem.homeView)) {
    on<NavigateTo>(_onNavigateTo);
  }

  void _onNavigateTo(NavigateTo event, Emitter<NavDrawerState> emit) {
    if (event.destination != state.selectedItem) {
      emit(NavDrawerState(event.destination));
    }
  }
}
