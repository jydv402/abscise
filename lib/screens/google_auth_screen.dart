// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:abscise/routes/app_router.dart';
// import 'package:iconify_flutter/icons/ph.dart';

// import 'package:abscise/providers/shared_prefs_provider.dart';
// import 'package:abscise/themes/app_theme.dart';
// import 'package:abscise/widgets/stack_button_widget.dart';
// import 'package:abscise/widgets/status_card_widget.dart';
// import 'package:abscise/controllers/google_auth_controller.dart';
// import 'package:abscise/models/google_auth_state.dart';

// class GoogleAuthScreen extends ConsumerStatefulWidget {
//   const GoogleAuthScreen({super.key});

//   @override
//   ConsumerState<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
// }

// class _GoogleAuthScreenState extends ConsumerState<GoogleAuthScreen> {
//   bool _consentAccepted = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//           _consentAccepted = ref
//               .read(appPreferencesProvider)
//               .getGooglePhotosConsentAccepted();
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Listen for authentication stream changes to handle reactive navigation
//     ref.listen<GoogleAuthState>(googleAuthControllerProvider, (previous, next) {
//       if (next.status == AuthStatus.authenticated ||
//           next.status == AuthStatus.skipped) {
//         context.go('/local');
//       } else if (next.status == AuthStatus.unauthenticated &&
//           next.errorMsg != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: AppTheme.deleteRed,
//             content: Text(
//               next.errorMsg!,
//               style: const TextStyle(fontFamily: 'Outfit'),
//             ),
//           ),
//         );
//       }
//     });

//     final authState = ref.watch(googleAuthControllerProvider);
//     final isProcessing = authState.status == AuthStatus.checking;

//     return Scaffold(
//       body: ListView(
//         padding: AppTheme.paddingXL,
//         children: [
//           Text(
//             'Sign in with Google',
//             style: Theme.of(context).textTheme.headlineLarge,
//           ),
//           Container(
//             margin: const EdgeInsets.only(top: 16),
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: AppTheme.secondaryPurple,
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(AppTheme.borderRadius),
//                 bottom: const Radius.circular(4),
//               ),
//             ),
//             child: Text(
//               'Unlock remote library decluttering with Google Photos Integration:',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//           ),
//           StatusCard(
//             title: 'Cloud Sync Swipe Deck',
//             subtitle:
//                 'Seamlessly swipe remote Google Photos. Swipe right to keep them, swipe left to clear library space.',
//             startIcon: Ph.google_photos_logo_duotone,
//             isFirst: true,
//             isLast: true,
//           ),
//           StatusCard(
//             title: 'Safe Remote Bin Album',
//             subtitle:
//                 'Swiped-left items are safely compiled inside a private "Abscise Bin" album on Google Photos. No cloud items are permanently deleted without your manual control.',
//             startIcon: Ph.trash_duotone,
//             isFirst: true,
//             isLast: true,
//           ),
//           StatusCard(
//             title: 'Encrypted OAuth Authentication',
//             subtitle:
//                 'Connect directly using secure Google OAuth. Your tokens, credentials, and photos are strictly private and never sent to external servers.',
//             startIcon: Ph.shield_check_duotone,
//             isFirst: true,
//             isLast: true,
//           ),
//           StatusCard(
//             title: 'Why Google Photo Permissions are Required?',
//             subtitle:
//                 'Abscise requests limited-access API scope to read media metadata, display cloud photos on your swipe deck, create the custom "Abscise Bin" album, and add swiped-left items to that album. It does NOT request administrative permission to delete files directly from your cloud.',
//             startIcon: Ph.question_duotone,
//           ),
//           const SizedBox(height: 24),
//           // Interactive Legal Consent Box
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Checkbox(
//                 value: _consentAccepted,
//                 onChanged: isProcessing
//                     ? null
//                     : (val) {
//                         final newValue = val ?? false;
//                         setState(() {
//                           _consentAccepted = newValue;
//                         });
//                         final prefs = ref.read(appPreferencesProvider);
//                         prefs.setGooglePhotosConsentAccepted(newValue);
//                         if (newValue) {
//                           prefs.setGooglePhotosConsentTimestamp(
//                             DateTime.now().toUtc().toIso8601String(),
//                           );
//                         } else {
//                           prefs.setGooglePhotosConsentTimestamp(null);
//                         }
//                       },
//                 activeColor: AppTheme.primaryPurple,
//                 checkColor: AppTheme.darkBackground,
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: RichText(
//                   text: TextSpan(
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppTheme.textWhite,
//                       fontSize: 14,
//                       height: 1.4,
//                     ),
//                     children: [
//                       const TextSpan(
//                         text: 'I read and explicitly consent to the ',
//                       ),
//                       TextSpan(
//                         text: 'Google Photos Terms & Privacy Policy',
//                         style: const TextStyle(
//                           color: AppTheme.primaryPurple,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () async {
//                             final accepted = await context.push<bool>(
//                               '/google-privacy',
//                             );
//                             if (accepted == true) {
//                               setState(() {
//                                 _consentAccepted = true;
//                               });
//                               final prefs = ref.read(appPreferencesProvider);
//                               prefs.setGooglePhotosConsentAccepted(true);
//                               prefs.setGooglePhotosConsentTimestamp(
//                                 DateTime.now().toUtc().toIso8601String(),
//                               );
//                             }
//                           },
//                       ),
//                       const TextSpan(
//                         text:
//                             '. I authorize Abscise to link my account and manage my Google Photos library strictly by adding chosen items into the "Abscise Bin" album.',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),

//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         spacing: 12,
//         children: [
//           StackButton(
//             label: 'Skip for now',
//             iconifyIcon: Ph.arrow_arc_right,
//             onPressed: isProcessing
//                 ? () {}
//                 : () {
//                     ref.read(googleAuthControllerProvider.notifier).skip();
//                   },
//             variant: ButtonVariant.secondary,
//           ),
//           StackButton(
//             label: isProcessing ? 'Logging in...' : 'Login with Google',
//             iconifyIcon: Ph.google_logo_bold,
//             onPressed: isProcessing
//                 ? () {}
//                 : () {
//                     if (!_consentAccepted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           backgroundColor: AppTheme.deleteRed,
//                           content: Text(
//                             'Please read and accept the Google Photos Terms & Privacy Policy first.',
//                             style: TextStyle(fontFamily: 'Outfit'),
//                           ),
//                         ),
//                       );
//                       return;
//                     }
//                     ref.read(googleAuthControllerProvider.notifier).login();
//                   },
//             variant: isProcessing
//                 ? ButtonVariant.secondary
//                 : ButtonVariant.primary,
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: .centerFloat,
//     );
//   }
// }
