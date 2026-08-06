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

class NavBarVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void show() => state = true;
  void hide() => state = false;
}

final navBarVisibilityProvider = NotifierProvider<NavBarVisibilityNotifier, bool>(
  NavBarVisibilityNotifier.new,
);

