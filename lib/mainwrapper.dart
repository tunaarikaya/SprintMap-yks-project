import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintmap/bloc/nav_drawer_bloc.dart';
import 'package:sprintmap/bloc/nav_drawer_state.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:sprintmap/views/sidebar_view/ai_view.dart';
import 'package:sprintmap/views/home_view.dart';
import 'package:sprintmap/views/sidebar_view/questions_view.dart';
import 'package:sprintmap/views/sidebar_view/todo_view.dart';
import 'package:sprintmap/views/sidebar_view/goals_view.dart';
import 'package:sprintmap/views/sidebar_view/statistics_view.dart';
import 'package:sprintmap/views/sidebar_view/results_view.dart';
import 'package:sprintmap/views/sidebar_view/libraries_view.dart';
import 'package:sprintmap/views/sidebar_view/badges_view.dart';
import 'package:sprintmap/views/sidebar_view/counter_view.dart';
import 'package:sprintmap/views/setting_view.dart';
import 'package:sprintmap/widget/drawer_widget.dart';
import 'package:sprintmap/widget/info_builder.dart';
import 'package:iconly/iconly.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  MainWrapperState createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  /// NavDrawer Bloc
  late NavDrawerBloc _bloc;

  /// Current content widget based on the selected drawer item
  late Widget _content;

  @override
  void initState() {
    super.initState();
    _bloc = NavDrawerBloc();
    _content = _getContentForState(_bloc.state.selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavDrawerBloc>(
      create: (BuildContext context) => _bloc,
      child: BlocConsumer<NavDrawerBloc, NavDrawerState>(
        listener: (BuildContext context, NavDrawerState state) {
          setState(() {
            _content = _getContentForState(state.selectedItem);
          });
        },
        buildWhen: (previous, current) =>
            previous.selectedItem != current.selectedItem,
        listenWhen: (previous, current) =>
            previous.selectedItem != current.selectedItem,
        builder: (BuildContext context, NavDrawerState state) {
          return Scaffold(
            drawer: NavDrawerWidget(),
            appBar: _buildAppBar(state),
            body: AnimatedSwitcher(
              switchInCurve: Curves.easeInExpo,
              switchOutCurve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 400),
              child: _content,
            ),
            bottomNavigationBar: const InfoBuilder(),
          );
        },
      ),
    );
  }

  /// Builds the AppBar with title based on the selected drawer item
  AppBar _buildAppBar(NavDrawerState state) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        _getAppBarTitle(state.selectedItem),
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: false,
      backgroundColor: AppTheme.tertiaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  /// Returns the content widget based on the selected drawer item
  Widget _getContentForState(NavItem selectedItem) {
    switch (selectedItem) {
      case NavItem.homeView:
        return const HomeView();
      case NavItem.todoView:
        return const ToDoView();
      case NavItem.questionsView:
        return const QuestionsView();
      case NavItem.aiView:
        return const AiView();
      case NavItem.goalsView:
        return const GoalsView();
      case NavItem.statisticsView:
        return const StatisticsView();
      case NavItem.resultsView:
        return const ResultsView();
      case NavItem.librariesView:
        return const LibrariesView();
      case NavItem.badgesView:
        return const BadgesView();
      case NavItem.counterView:
        return const CounterView();
      case NavItem.settingsView:
        return const SettingView();
      default:
        return Container();
    }
  }

  /// Returns the AppBar title based on the selected drawer item
  String _getAppBarTitle(NavItem selectedItem) {
    switch (selectedItem) {
      case NavItem.homeView:
        return "Ana Sayfa";
      case NavItem.todoView:
        return "Yapılacaklar";
      case NavItem.questionsView:
        return "Biriken Sorular";
      case NavItem.aiView:
        return "Yapay Zeka";
      case NavItem.goalsView:
        return "Hedeflerim";
      case NavItem.statisticsView:
        return "YKS İstatistiği";
      case NavItem.resultsView:
        return "Deneme Sonuçları";
      case NavItem.librariesView:
        return "Yakındaki Kütüphaneler";
      case NavItem.badgesView:
        return "Rozetlerim";
      case NavItem.counterView:
        return "Sayaç";
      case NavItem.settingsView:
        return "Ayarlar";
      default:
        return "Navigation Drawer Demo";
    }
  }
}
