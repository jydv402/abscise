import 'package:abscise/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

void checkForUpdates(BuildContext context, bool showIfUpToDate) async {
  await UpdateChecker.check(
    context,
    githubRepo: "jydv402/abscise",
    style: .alertDialog,
    showRedirectButton: true,
    borderRadius: 32,
    backgroundColor: AppTheme.secondaryPurple,
    showIfUpToDate: showIfUpToDate,
    accentColor: AppTheme.tertiaryLime,
    accentTextColor: AppTheme.secondaryPurple,
    secondaryTextColor: AppTheme.textSecondary,
    titleStyle: Theme.of(context).textTheme.headlineSmall,
  );
}
