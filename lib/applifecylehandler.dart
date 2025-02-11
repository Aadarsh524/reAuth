import 'package:flutter/material.dart';
import 'package:reauth/lock_screen.dart';

class AppLifecycleHandler extends StatefulWidget {
  final Widget child;
  const AppLifecycleHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<AppLifecycleHandler> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends State<AppLifecycleHandler>
    with WidgetsBindingObserver {
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      setState(() {
        _isLocked = true;
      });
    }
  }

  void _unlockApp() {
    setState(() {
      _isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLocked ? LockScreen(onUnlock: _unlockApp) : widget.child;
  }
}
