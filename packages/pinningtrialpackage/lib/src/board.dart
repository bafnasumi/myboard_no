// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, curly_braces_in_flow_control_structures, sort_child_properties_last

library pinningtrialpackage;

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:pinningtrialpackage/src/helper/operat_state.dart';

import 'case_group/adaptive_text_case.dart';
import 'case_group/drawing_board_case.dart';
import 'case_group/item_case.dart';
import 'helper/case_style.dart';
import 'item_group/adaptive_text.dart';
import 'item_group/stack_board_item.dart';
import 'item_group/stack_drawing.dart';

class StackBoard extends StatefulWidget {
  const StackBoard({
    Key? key,
    this.controller,
    this.background,
    this.caseStyle = const CaseStyle(),
    this.customBuilder,
    this.tapToCancelAllItem = false,
    this.tapItemToMoveTop = true,
  }) : super(key: key);

  @override
  _StackBoardState createState() => _StackBoardState();

  final StackBoardController? controller;

  final Widget? background;

  final CaseStyle? caseStyle;

  final Widget? Function(StackBoardItem item)? customBuilder;

  final bool tapToCancelAllItem;

  final bool tapItemToMoveTop;
}

class _StackBoardState extends State<StackBoard> with SafeState<StackBoard> {
  late List<StackBoardItem> _children;

  int _lastId = 0;

  OperatState? _operatState;

  Key _getKey(int? id) => Key('StackBoardItem$id');

  @override
  void initState() {
    super.initState();
    _children = <StackBoardItem>[];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller?._stackBoardState = this;
  }

  void _add<T extends StackBoardItem>(StackBoardItem item) {
    if (_children.contains(item)) throw 'duplicate id';

    _children.add(item.copyWith(
      id: item.id ?? _lastId,
      caseStyle: item.caseStyle ?? widget.caseStyle,
    ));

    _lastId++;
    safeSetState(() {});
  }

  void _remove(int? id) {
    _children.removeWhere((StackBoardItem b) => b.id == id);
    safeSetState(() {});
  }

  void _moveItemToTop(int? id) {
    if (id == null) return;

    final StackBoardItem item =
        _children.firstWhere((StackBoardItem i) => i.id == id);
    _children.removeWhere((StackBoardItem i) => i.id == id);
    _children.add(item);

    safeSetState(() {});
  }

  void _clear() {
    _children.clear();
    _lastId = 0;
    safeSetState(() {});
  }

  void _unFocus() {
    _operatState = OperatState.complate;
    safeSetState(() {});
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      _operatState = null;
      safeSetState(() {});
    });
  }

  Future<void> _onDel(StackBoardItem box) async {
    final bool del = (await box.onDel?.call()) ?? true;
    if (del) _remove(box.id);
  }

  @override
  Widget build(BuildContext context) {
    Widget _child;

    if (widget.background == null)
      _child = Stack(
        fit: StackFit.expand,
        children:
            _children.map((StackBoardItem box) => _buildItem(box)).toList(),
      );
    else
      _child = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.background!,
          ..._children.map((StackBoardItem box) => _buildItem(box)).toList(),
        ],
      );

    if (widget.tapToCancelAllItem) {
      _child = GestureDetector(
        onTap: _unFocus,
        child: _child,
      );
    }

    return _child;
  }

  Widget _buildItem(StackBoardItem item) {
    Widget child = ItemCase(
      key: _getKey(item.id),
      child: Container(
        width: 150,
        height: 150,
        alignment: Alignment.center,
        child: const Text(
            'unknow item type, please use customBuilder to build it'),
      ),
      onDel: () => _onDel(item),
      onTap: () => _moveItemToTop(item.id),
      caseStyle: item.caseStyle,
      operatState: _operatState,
    );

    if (item is AdaptiveText) {
      child = AdaptiveTextCase(
        key: _getKey(item.id),
        adaptiveText: item,
        onDel: () => _onDel(item),
        onTap: () => _moveItemToTop(item.id),
        operatState: _operatState,
      );
    } else if (item is StackDrawing) {
      child = DrawingBoardCase(
        key: _getKey(item.id),
        stackDrawing: item,
        onDel: () => _onDel(item),
        onTap: () => _moveItemToTop(item.id),
        operatState: _operatState,
      );
    } else {
      child = ItemCase(
        key: _getKey(item.id),
        child: item.child,
        onDel: () => _onDel(item),
        onTap: () => _moveItemToTop(item.id),
        caseStyle: item.caseStyle,
        operatState: _operatState,
      );

      if (widget.customBuilder != null) {
        final Widget? customWidget = widget.customBuilder!.call(item);
        if (customWidget != null) return child = customWidget;
      }
    }

    return child;
  }
}

class StackBoardController {
  _StackBoardState? _stackBoardState;

  void _check() {
    if (_stackBoardState == null) throw '_stackBoardState is empty';
  }

  void add<T extends StackBoardItem>(T item) {
    _check();
    _stackBoardState?._add<T>(item);
  }

  void remove(int? id) {
    _check();
    _stackBoardState?._remove(id);
  }

  void moveItemToTop(int? id) {
    _check();
    _stackBoardState?._moveItemToTop(id);
  }

  void clear() {
    _check();
    _stackBoardState?._clear();
  }

  void refresh() {
    _check();
    _stackBoardState?.safeSetState(() {});
  }

  void dispose() {
    _stackBoardState = null;
  }
}
