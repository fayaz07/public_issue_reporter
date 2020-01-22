import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

/// Copyright
/// https://github.com/fayaz07/awesome_widgets
// ignore: must_be_immutable
// ignore: must_be_immutable
class DropDownButton extends StatefulWidget {
  List items;
  var selectedItem;
  String title;
  Function(dynamic) onSelected;

  DropDownButton(
      {@required this.items, @required this.title, @required this.onSelected}) {
    assert(items != null);
    assert(items.length > 0);
    selectedItem = items[0];
    title = title ?? "Select your choice";
    onSelected = onSelected ?? (value) => print(value);
  }

  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton>
    with SingleTickerProviderStateMixin {
  /// Animation
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.0),
          InkWell(
            onTap: () {
//              if (animation.status == AnimationStatus.completed) {
//                //  animationController.reverse();
//              } else
//                 animationController.forward();
              /// Handling tap on dropdownbutton and showing all values to be selected
              if (_animation.status != AnimationStatus.completed) {
                _animationController.forward();
              }
            },
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Colors.black)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    // Showing value
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.selectedItem.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                    //  Selectables
                    SizeTransition(
                      sizeFactor: _animation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                              physics: Platform.isAndroid
                                  ? ClampingScrollPhysics()
                                  : BouncingScrollPhysics(),
                              itemCount: widget.items.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _animationController.reverse();
                                      widget.selectedItem = widget.items[i];
                                    });
                                    widget.onSelected(widget.selectedItem);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    child: Text(
                                      widget.items[i],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
