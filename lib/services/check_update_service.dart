import 'package:flutter/material.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

void checkForUpdates(BuildContext context) async {
  await UpdateChecker.check(
    context,
    githubRepo: "jydv402/memno",
    style: .alertDialog,
  );
}
