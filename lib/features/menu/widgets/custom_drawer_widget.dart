import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/menu/domain/enums/drawer_state_enun.dart';
import 'package:flutter_grocery/features/menu/domain/models/custom_drawer_controller_model.dart';
import 'package:flutter_grocery/common/providers/localization_provider.dart';
import 'package:provider/provider.dart';



class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({super.key,
    this.controller,
    required this.menuScreen,
    required this.mainScreen,
    this.slideWidth = 275.0,
    this.borderRadius = 16.0,
    this.angle = -12.0,
    this.backgroundColor = Colors.white,
    this.showShadow = false,
    this.openCurve,
    this.closeCurve,
  }) : assert(angle <= 0.0 && angle >= -30.0);

  final CustomDrawerController? controller;
  final Widget menuScreen;
  final Widget mainScreen;
  final double slideWidth;
  final double borderRadius;
  final double angle;
  final Color backgroundColor;
  final bool showShadow;
  final Curve? openCurve;
  final Curve? closeCurve;

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();

  /// static function to provide the drawer state
  static State<CustomDrawerWidget>? of(BuildContext context) {
    return context.findAncestorStateOfType<State<CustomDrawerWidget>>() as _CustomDrawerWidgetState?;
  }

  /// Static function to determine the device text direction RTL/LTR
  static bool isRTL(BuildContext context) {
    return !Provider.of<LocalizationProvider>(context, listen: false).isLtr;
  }
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget>
    with SingleTickerProviderStateMixin {
  /// check the slide direction


  late AnimationController _animationController;
  DrawerState _state = DrawerState.closed;

  double get _percentOpen => _animationController.value;

  void open() {
    _animationController.forward();
  }

  void close() {
    _animationController.reverse();
  }

  void toggle() {
    if (_state == DrawerState.open) {
      close();
    } else if (_state == DrawerState.closed) {
      open();
    }
  }

  bool isOpen() =>
      _state == DrawerState.open  /*|| _state == DrawerState.opening*/;

  /// Drawer state
  ValueNotifier<DrawerState>? stateNotifier;

  @override
  void initState() {
    super.initState();

    stateNotifier = ValueNotifier(_state);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = DrawerState.opening;
            _updateStatusNotifier();
            break;
          case AnimationStatus.reverse:
            _state = DrawerState.closing;
            _updateStatusNotifier();
            break;
          case AnimationStatus.completed:
            _state = DrawerState.open;
            _updateStatusNotifier();
            break;
          case AnimationStatus.dismissed:
            _state = DrawerState.closed;
            _updateStatusNotifier();
            break;
        }
      });

    /// assign controller function to the widget methods
    if (widget.controller != null) {
      widget.controller!.open = open;
      widget.controller!.close = close;
      widget.controller!.toggle = toggle;
      widget.controller!.isOpen = isOpen;
      widget.controller!.stateNotifier = stateNotifier;
    }
  }

  void _updateStatusNotifier() {
    stateNotifier!.value = _state;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final bool rtl = CustomDrawerWidget.isRTL(context);

    return Stack(
      children: [
        // 1. Main Screen (flat background, stays at 100% scale)
        widget.mainScreen,

        // 2. Scrim Overlay (fades in and closes on tap/swipe)
        if (_percentOpen > 0.0)
          GestureDetector(
            onTap: close,
            onPanUpdate: (details) {
              if (details.delta.dx < -6 && !rtl || details.delta.dx < 6 && rtl) {
                close();
              }
            },
            child: Container(
              color: Colors.black.withValues(alpha: 0.4 * _percentOpen),
            ),
          ),

        // 3. Sliding Drawer Menu
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final int rtlSign = rtl ? 1 : -1;
            // slideAmount will translate from -slideWidth (closed) to 0.0 (open)
            final double slideAmount = widget.slideWidth * rtlSign * (1.0 - _percentOpen);

            return Positioned(
              left: rtl ? null : 0,
              right: rtl ? 0 : null,
              top: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(slideAmount, 0),
                child: Container(
                  width: widget.slideWidth,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15 * _percentOpen),
                        blurRadius: 16,
                        offset: Offset(rtl ? -4 : 4, 0),
                      )
                    ],
                  ),
                  child: widget.menuScreen,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Drawer State enum

