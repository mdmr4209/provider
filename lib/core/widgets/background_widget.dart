import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const BackgroundWidget({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/bg.png',
  });

  @override
  Widget build(BuildContext context) {
    final bool isDefaultBg = imagePath == 'assets/images/bg.png';
    // Use paddingOf to get the system status bar height
    final double topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: isDefaultBg
            ? const Color(0xFF111B10)
            : Colors.transparent,
        statusBarIconBrightness: isDefaultBg
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDefaultBg ? Brightness.dark : Brightness.light,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: isDefaultBg && topPadding > 0
            ? Column(
                children: [
                  // This container colors the status bar area
                  Container(height: topPadding, color: const Color(0xFF111B10)),
                  // We MUST remove the top padding for the child,
                  // otherwise any SafeArea or AppBar inside 'child'
                  // will add another gap, making it look "too big".
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: child,
                    ),
                  ),
                ],
              )
            : child,
      ),
    );
  }
}
