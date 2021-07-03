import 'dart:async';

import 'package:flutter/material.dart';

class PointerView extends StatefulWidget {
  final Widget child;

  const PointerView({required this.child, Key? key}) : super(key: key);

  @override
  _PointerViewState createState() => _PointerViewState();
}

class _PointerViewState extends State<PointerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  StreamController<Offset> _offset = StreamController.broadcast();

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurveTween(curve: Curves.fastOutSlowIn).animate(_controller));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerMove: (details) {
              _offset.sink.add(details.localPosition);
              _controller.reverse(from: 1.0);
            },
            onPointerDown: (details) {
              _offset.sink.add(details.localPosition);
              _controller.reverse(from: 1.0);
            },
            child: StreamBuilder<Offset>(
                stream: _offset.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Stack(
                    children: [
                      Positioned(
                        top: snapshot.data!.dy - 8,
                        left: snapshot.data!.dx - 8,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _animation.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }
}
