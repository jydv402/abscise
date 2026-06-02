import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavBarMode { pageSwitch, actionBar }

class NavBarModeController extends Notifier<NavBarMode> {
  @override
  NavBarMode build() => NavBarMode.pageSwitch;

  void switchToPageSwitch() => state = NavBarMode.pageSwitch;
  void switchToActionBar() => state = NavBarMode.actionBar;
}

final navBarModeProvider = NotifierProvider<NavBarModeController, NavBarMode>(
  NavBarModeController.new,
);
