import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomWindowFrame extends StatelessWidget {
  final Widget child;

  const CustomWindowFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WindowTitleBar(),
        Expanded(child: child),
      ],
    );
  }
}

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) async {
        await windowManager.startDragging();
      },
      child: Container(
        height: 32,
        color: const Color(0xFF1A1B1E),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Image.asset(
                    'assets/images/app_icon.png',
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'School Task Manager',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            _WindowButton(
              icon: PhosphorIcons.minus(PhosphorIconsStyle.bold),
              onPressed: () async {
                await windowManager.minimize();
              },
              hoverColor: Colors.white.withOpacity(0.1),
            ),
            _WindowButton(
              icon: PhosphorIcons.square(PhosphorIconsStyle.bold),
              onPressed: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
              hoverColor: Colors.white.withOpacity(0.1),
            ),
            _WindowButton(
              icon: PhosphorIcons.x(PhosphorIconsStyle.bold),
              onPressed: () async {
                await windowManager.close();
              },
              hoverColor: Colors.red.withOpacity(0.8),
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color hoverColor;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    required this.hoverColor,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 46,
          height: double.infinity,
          color: isHovered ? widget.hoverColor : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 16,
            color: isHovered && widget.isClose ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
