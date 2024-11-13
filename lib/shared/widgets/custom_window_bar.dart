import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CustomWindowBar extends StatelessWidget {
  const CustomWindowBar({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: MoveWindow(),
            ),
            Row(
              children: [
                MinimizeWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: Colors.white70,
                    mouseOver: Colors.white.withOpacity(0.1),
                    mouseDown: Colors.white.withOpacity(0.2),
                    iconMouseOver: Colors.white,
                  ),
                ),
                MaximizeWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: Colors.white70,
                    mouseOver: Colors.white.withOpacity(0.1),
                    mouseDown: Colors.white.withOpacity(0.2),
                    iconMouseOver: Colors.white,
                  ),
                ),
                CloseWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: Colors.red.shade400,
                    mouseOver: Colors.red.withOpacity(0.1),
                    mouseDown: Colors.red.withOpacity(0.2),
                    iconMouseOver: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
