import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/dimensions.dart';

class CustomShadowWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final bool isActive;
  const CustomShadowWidget({
    super.key, required this.child, this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16.0,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return isActive ? Container(
      padding: padding ,
      margin:  margin,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius!),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 24,
            color: Colors.black.withValues(alpha: 0.04),
          ),
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: child,
    ) : child;
  }
}
