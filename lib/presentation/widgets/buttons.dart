// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:events_planning/presentation/utils/utils.dart';
// import 'package:flutter/material.dart';
//
// class RippleButton extends StatelessWidget {
//   final String text;
//   final Widget? prefixWidget;
//   final Widget? suffixWidget;
//   final VoidCallback onTap;
//
//   const RippleButton({
//     Key? key,
//     required this.text,
//     required this.onTap,
//     this.prefixWidget,
//     this.suffixWidget,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: AppTheme.purpleGradient.withHorizontalGradient,
//         boxShadow: AppTheme.getShadow(AppTheme.cornflowerBlue),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               prefixWidget ?? Container(),
//               AutoSizeText(
//                 text,
//                 style: AppTheme.text1.withWhite,
//                 textAlign: TextAlign.center,
//                 minFontSize: 8,
//                 maxLines: 1,
//               ),
//               suffixWidget ?? Container(),
//             ],
//           )).addRipple(onTap: onTap),
//     );
//   }
// }
//
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class RippleButton extends StatelessWidget {
  final String text;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final VoidCallback onTap;

  const RippleButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.prefixWidget,
    this.suffixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bottomAddSheetDate,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              prefixWidget ?? Container(),
              AutoSizeText(
                text,
                style: AppTheme.eventPanelHeadline.withWhite,
                textAlign: TextAlign.center,
                minFontSize: 8,
                maxLines: 1,
              ),
              suffixWidget ?? Container(),
            ],
          )).addRipple(onTap: onTap),
    );
  }
}

class RippleCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const RippleCircleButton({
    Key? key,
    required this.onTap, required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.birthdayGradient,
        boxShadow: AppTheme.getShadow(AppTheme.purpleBlue),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: child,
      ).addRipple(onTap: onTap),
    );
  }
}

class PinkButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onTap;

  const PinkButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.addButton,
        boxShadow: AppTheme.getShadow(AppTheme.birthdayGradient.withVerticalGradient.colors[0]),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            SizedBox(width: 8),
            Text(
              text,
              style: AppTheme.eventPanelHeadline.withWhite,
              textAlign: TextAlign.center,

            ),
          ],
        )
            : Text(
          text,
          style: AppTheme.eventPanelHeadline.withWhite,
          textAlign: TextAlign.center,
        ),
      ).addRipple(onTap: onTap),
    );
  }
}
