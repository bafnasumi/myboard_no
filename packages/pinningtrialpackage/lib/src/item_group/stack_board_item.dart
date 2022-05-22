import 'package:flutter/widgets.dart';
import 'package:pinningtrialpackage/src/helper/case_style.dart';

@immutable
class StackBoardItem {
  const StackBoardItem({
    required this.child,
    this.id,
    this.onDel,
    this.caseStyle,
    this.tapToEdit = false,
  });

  final int? id;

  final Widget child;

  final Future<bool> Function()? onDel;

  final CaseStyle? caseStyle;

  final bool tapToEdit;

  StackBoardItem copyWith({
    int? id,
    Widget? child,
    Future<bool> Function()? onDel,
    CaseStyle? caseStyle,
    bool? tapToEdit,
  }) =>
      StackBoardItem(
        id: id ?? this.id,
        child: child ?? this.child,
        onDel: onDel ?? this.onDel,
        caseStyle: caseStyle ?? this.caseStyle,
        tapToEdit: tapToEdit ?? this.tapToEdit,
      );

  bool sameWith(StackBoardItem item) => item.id == id;

  @override
  bool operator ==(Object other) => other is StackBoardItem && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
