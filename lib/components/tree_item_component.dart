import 'package:flutter/material.dart';

class CustomTree extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;

  CustomTree({
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  _CustomTreeState createState() => _CustomTreeState();
}

class _CustomTreeState extends State<CustomTree> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Visibility(
              visible: widget.children.isNotEmpty,
              child: AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: _isExpanded ? 0.5 : 0.0,
              child: const Icon(Icons.expand_more),
            )),
          ),
          title: widget.title,
          subtitle: widget.subtitle,
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Column(
            children: widget.children,
          ),
      ],
    );
  }
}