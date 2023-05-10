import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMinimize;
  final VoidCallback onMaximize;
  final VoidCallback onClose;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onMinimize,
    required this.onMaximize,
    required this.onClose,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isCloseButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) async {
        await windowManager.startDragging();
      },
      onPanUpdate: (details) {},
      onPanEnd: (details) {},
      child: SizedBox(
        height: 50,
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.minimize,
                size: 15,
              ),
              onPressed: widget.onMinimize,
            ),
            IconButton(
              icon: const Icon(
                Icons.crop_square,
                size: 15,
              ),
              onPressed: widget.onMaximize,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: MouseRegion(
                onEnter: (event) =>
                    setState(() => _isCloseButtonHovered = true),
                onExit: (event) =>
                    setState(() => _isCloseButtonHovered = false),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                  color: _isCloseButtonHovered
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  onPressed: widget.onClose,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
