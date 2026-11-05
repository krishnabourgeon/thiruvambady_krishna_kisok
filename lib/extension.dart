import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';

extension Log on Object {
  void log(String s, {String name = ''}) => devtools.log(toString(), name: name);
}

extension WidgetExtension on Widget {
  Widget animatedSwitch({
    Curve? curvesIn,
    Curve? curvesOut,
    int duration = 200,
    int reverseDuration = 200,
  }) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      reverseDuration: Duration(milliseconds: reverseDuration),
      switchInCurve: curvesIn ?? Curves.linear,
      switchOutCurve: curvesOut ?? Curves.linear,
      child: this,
    );
  }

  static Widget crossSwitch({
    required Widget first,
    Widget second = const SizedBox.shrink(),
    required bool value,
    Curve curvesIn = Curves.linear,
    Curve curvesOut = Curves.linear,
  }) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      crossFadeState:
          value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
      firstCurve: curvesIn,
      secondCurve: curvesOut,
    );
  }
}

extension InkWellExtension on InkWell {
  InkWell removeSplash({Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      splashColor: color,
      highlightColor: color,
      child: child,
    );
  }
}

extension TranslateWidgetVertically on Widget {
  Widget translateWidgetVertically({double value = 0}) {
    return Transform.translate(offset: Offset(0.0, value), child: this);
  }
}

extension TranslateWidgetHorizontally on Widget {
  Widget translateWidgetHorizontally({double value = 0}) {
    return Transform.translate(offset: Offset(value, 0.0), child: this);
  }
}

extension ConvertToSliver on Widget {
  Widget convertToSliver() {
    return SliverToBoxAdapter(child: this);
  }
}

extension Context on BuildContext {
  double sh({double size = 1.0}) {
    return MediaQuery.of(this).size.height * size;
  }

  double sw({double size = 1.0}) {
    return MediaQuery.of(this).size.width * size;
  }

  int cacheSize(double size) {
    return (size * MediaQuery.of(this).devicePixelRatio).round();
  }

  void get rootPop => Navigator.of(this, rootNavigator: true).pop();
}

extension TextExtension on Text {
  Text avoidOverFlow({int maxLine = 1}) {
    return Text(
      (data ?? '').trim().replaceAll('', '\u200B'),
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text addEllipsis({int maxLine = 1}) {
    return Text(
      (data ?? '').trim(),
      style: style,
      strutStyle: strutStyle,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}

extension StringExtension on String? {
  bool get notEmpty => (this ?? '').isNotEmpty;
  bool get empty => (this ?? '').isNotEmpty;
}

extension ListExtension on List? {
  bool get notEmpty => (this ?? []).isNotEmpty;
}

// extension AddShimmer on Widget {
//   Widget addShimmer({Color? baseColor, Color? highlightColor}) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade100,
//       highlightColor: Colors.white.withOpacity(.50),
//       child: this,
//     );
//   }
// }

extension BoolParsing on String {
  bool parseBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    } else {
      return false;
    }
  }
}

extension PaddingExtension on Widget {
  Widget leftPadding(double padding) {
    return Padding(padding: EdgeInsets.only(left: padding), child: this);
  }

  Widget rightPadding(double padding) {
    return Padding(padding: EdgeInsets.only(right: padding), child: this);
  }

  Widget topPadding(double padding) {
    return Padding(padding: EdgeInsets.only(top: padding), child: this);
  }

  Widget bottomPadding(double padding) {
    return Padding(padding: EdgeInsets.only(bottom: padding), child: this);
  }

  Widget verticalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  Widget horizontalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  Widget allPadding(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  Widget symmetricPadding({
    required double vertical,
    required double horizontal,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }
}
