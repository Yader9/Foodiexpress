import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionTimeout extends StatefulWidget {
  final Widget child;

  const SessionTimeout({super.key, required this.child});

  @override
  State<SessionTimeout> createState() => _SessionTimeoutState();
}

class _SessionTimeoutState extends State<SessionTimeout> {
  Timer? _timer;

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(minutes: 10), () {
      FirebaseAuth.instance.signOut();
    });
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      onPanDown: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}