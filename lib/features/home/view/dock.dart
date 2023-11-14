import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotspot/app/color_palette.dart';

class Dock extends StatefulWidget {
  final bool accessibility_mode;
  final DockController? controller;
  final int initialIndex;
  final List<DockItem> items;
  final ValueChanged<int> onTap;
  Color? defaultSelectedColor = Colors.red;
  Color? defaultUnselectedColor = Colors.white;

  Dock({
    super.key,
    this.accessibility_mode = false,
    this.controller,
    required this.initialIndex,
    required this.items,
    required this.onTap,
    this.defaultSelectedColor,
    this.defaultUnselectedColor,
  });

  @override
  State<Dock> createState() => DockState();
}

class DockState extends State<Dock> with TickerProviderStateMixin {
  int currentIndexAbs = 0;
  int currentIndexAbsDelayed = 0;
  int lastIndexAbs = 0;
  List<int> indexes = <int>[];
  List<int> indexesAbs = <int>[];

  @override
  void initState() {
    currentIndexAbs = widget.initialIndex;
    currentIndexAbsDelayed = widget.initialIndex;
    lastIndexAbs = widget.initialIndex;

    widget.controller?.addListener(() {
      if (widget.controller!.setCurrentIndex) {
        setIndex(indexes[widget.controller!.currentIndex], indexesAbs[widget.controller!.currentIndex]);
      }
      if (widget.controller!.setCurrentSliderIndex) {
        setSliderIndex(
            indexes[widget.controller!.currentSliderIndex], indexesAbs[widget.controller!.currentSliderIndex]);
      }
    });

    super.initState();
  }

  void setIndex(int index, indexAbs) {
    setState(() {
      widget.onTap.call(index);
      setDelayedIndex();
      currentIndexAbs = indexAbs;
      widget.controller?.currentIndex = indexAbs;
    });
  }

  void setSliderIndex(int index, indexAbs) {
    setState(() {
      setDelayedIndex();
      currentIndexAbs = indexAbs;
      widget.controller?.currentIndex = indexAbs;
    });
  }

  void setDelayedIndex() {
    var timer = Future.delayed(const Duration(milliseconds: 40));
    timer.whenComplete(() {
      setState(() {
        currentIndexAbsDelayed = currentIndexAbs;
        lastIndexAbs = currentIndexAbs;
      });
    });
  }

  bool getTabDirection() {
    if (currentIndexAbs > lastIndexAbs || currentIndexAbs == lastIndexAbs) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double dockWidth = MediaQuery.of(context).size.width - 40;
    double tileWidth = dockWidth / widget.items.length;
    var tiles = createTiles(tileWidth);
    widget.controller?.indexes = indexes;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).padding.bottom),
      child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 60,
            child: Stack(
              children: [
                Container(
                  color: MediaQuery.of(context).platformBrightness == Brightness.light ? columbiaBlue : oxfordBlue,
                ),
                AnimatedPositioned(
                  top: 0,
                  bottom: 0,
                  left:
                      tileWidth * (getTabDirection() ? currentIndexAbsDelayed.toDouble() : currentIndexAbs.toDouble()) +
                          ((currentIndexAbsDelayed == 0 || currentIndexAbsDelayed == widget.items.length - 1) ? 10 : 0),
                  right: dockWidth -
                      (tileWidth *
                              (getTabDirection() ? currentIndexAbs.toDouble() : currentIndexAbsDelayed.toDouble()) +
                          tileWidth) +
                      ((currentIndexAbsDelayed == widget.items.length - 1 || currentIndexAbsDelayed == 0) ? 10 : 0),
                  duration: const Duration(milliseconds: 300),
                  curve: const Cubic(0, 0, 0, 1),
                  child: Center(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MediaQuery.of(context).platformBrightness == Brightness.light ? biceBlue : sapphire,
                          boxShadow: [
                            BoxShadow(blurRadius: 50, color: MediaQuery.of(context).platformBrightness == Brightness.light ? biceBlue : sapphire),
                          ]),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: tiles,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  List<_DockTile> createTiles(double width) {
    indexes = [];
    indexesAbs = [];
    List<_DockTile> tabTiles = <_DockTile>[];
    int currIndex = 0;

    widget.items.asMap().forEach((i, item) {
      indexesAbs.add(i);
      indexes.add(currIndex);
      switch (item.runtimeType) {
        case DockTabItem:
          _DockTabTile tile = _DockTabTile(
            icon: item.icon,
            width: width,
            callback: () {
              setIndex(indexes[i], indexesAbs[i]);
              widget.controller?.currentIndex = indexesAbs[1];
              HapticFeedback.mediumImpact();
            },
            child: (item as DockTabItem).child,
          );
          tabTiles.add(tile);
          currIndex++;
          break;
        case DockFunctionItem:
          _DockFunctionTile tile = _DockFunctionTile(
            backgroundColor: (item as DockFunctionItem).iconColor,
            function: item.function,
            icon: item.icon,
            width: width,
            child: item.child,
          );
          tabTiles.add(tile);
          break;
      }
    });
    widget.controller?.size = tabTiles.length;
    return tabTiles;
  }
}

abstract class _DockTile extends StatelessWidget {
  final IconData? icon;
  final double width;
  Color? selectedColor;
  Color? unselectedColor;

  _DockTile({
    this.icon,
    required this.width,
  });
}

class _DockTabTile extends _DockTile {
  final void Function() callback;
  Widget? child;
  _DockTabTile({super.icon, required super.width, required this.callback, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: callback,
      child: Container(
        width: width,
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1,
          child: child ??
              Icon(
                icon,
                color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.grey[100] : Colors.white,
              ),
        ),
      ),
    );
  }
}

class _DockFunctionTile extends _DockTile {
  final void Function() function;
  final Color? backgroundColor;
  Widget? child;
  _DockFunctionTile(
      {required super.icon, required super.width, required this.function, this.backgroundColor, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: function,
      child: Container(
        color: Colors.transparent,
        width: width,
        child: child ??
            Icon(
              icon,
              color: backgroundColor,
            ),
      ),
    );
  }
}

class DockItem {
  final IconData? icon;

  DockItem({
    this.icon,
  });
}

class DockTabItem extends DockItem {
  Widget? child;

  DockTabItem({required super.icon, this.child});
}

class DockFunctionItem extends DockItem {
  final void Function() function;
  Color? iconColor = Colors.grey;
  Widget? child;

  DockFunctionItem({super.icon, required this.function, this.iconColor, this.child});
}

class DockController extends ChangeNotifier {
  int currentIndex = 0;
  bool setCurrentIndex = false;

  int currentSliderIndex = 0;
  bool setCurrentSliderIndex = false;

  int size = 0;

  List<int> indexes = [];

  void jumpTo(int index) {
    setCurrentIndex = true;
    currentIndex = index;
    notifyListeners();
    setCurrentIndex = false;
  }

  void moveSliderTo(int index) {
    setCurrentSliderIndex = true;
    currentSliderIndex = index;
    notifyListeners();
    setCurrentSliderIndex = false;
  }
}
