import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parallelchat/constants/constants.dart';

enum ButtonType { action, search }

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String? title;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final bool outline;
  final bool loading;
  final ButtonType? type;
  const CustomButton({
    Key? key,
    this.width,
    this.height,
    this.title,
    this.type = ButtonType.action,
    this.padding,
    this.color,
    this.onTap,
    this.outline = false,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      splashColor: Colors.white,
      child: Container(
        padding: padding ?? const EdgeInsets.only(left: 24, right: 20),
        width: width ?? double.infinity,
        height: height ?? 48,
        decoration: BoxDecoration(
          color: !outline ? color ?? const Color(IColors.yellow) : Colors.white,
          borderRadius: BorderRadius.circular((height ?? 48) / 2),
          border: Border.all(
            color: !outline
                ? Colors.transparent
                : color ?? const Color(IColors.yellow),
          ),
        ),
        child: loading
            ? Center(
                child: SpinKitRotatingCircle(
                  size: 30,
                  color: !outline
                      ? Colors.white
                      : color ?? const Color(IColors.yellow),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title ?? "",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: !outline
                              ? Colors.white
                              : color ?? const Color(IColors.yellow),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Icon(
                    type == ButtonType.action
                        ? Icons.arrow_right_alt
                        : Icons.search,
                    color: !outline
                        ? Colors.white
                        : color ?? const Color(IColors.yellow),
                  ),
                ],
              ),
      ),
    );
  }
}
