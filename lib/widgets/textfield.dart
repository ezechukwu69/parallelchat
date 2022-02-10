import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parallelchat/constants/constants.dart';
import 'package:parallelchat/widgets/form.dart';

class CustomTextFieldItem extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const CustomTextFieldItem({Key? key, this.onTap, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: child,
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String)? validate;
  final FocusNode? node;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? formatters;
  final TextInputType? inputType;
  final String? hint;
  final Color? color;
  final bool? obscured;
  final String? label;
  final CustomTextFieldItem? suffix;
  final CustomTextFieldItem? obscuredSuffix;
  final EdgeInsets? padding;
  const CustomTextField({
    Key? key,
    this.validate,
    required this.controller,
    this.color,
    this.hint,
    this.padding,
    this.suffix,
    this.obscuredSuffix,
    this.obscured,
    this.label,
    this.inputType,
    this.formatters,
    this.onSubmitted,
    this.node,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  String? message;
  bool hasFocus = false;
  bool obscured = false;

  bool validate() {
    if (widget.validate?.call(widget.controller.text.trim()) != null) {
      setState(() {
        message = widget.validate?.call(widget.controller.text.trim());
      });
      return false;
    } else {
      setState(() {
        message = null;
      });
      return true;
    }
  }

  void unfocus() {
    widget.node?.unfocus();
  }

  void clear() {
    setState(() {
      widget.controller.text = "";
    });
  }

  void toggleObscuredState() {
    setState(() {
      obscured = !obscured;
    });
  }

  void checkState() {
    hasFocus = widget.node?.hasFocus ?? false;
  }

  @override
  void initState() {
    super.initState();
    widget.node?.addListener(checkState);
    obscured = widget.obscured ?? false;
  }

  @override
  void dispose() {
    widget.node?.removeListener(checkState);
    super.dispose();
  }

  @override
  void deactivate() {
    CustomForm.of(context)?.unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    CustomForm.of(context)?.register(this);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...{
          Text(
            widget.label ?? "",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 12,
                  color: const Color(IColors.textLightBlack),
                ),
          ),
          const SizedBox(height: 4),
        },
        Container(
          padding: widget.padding ?? const EdgeInsets.only(left: 16, right: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasFocus && message == null
                  ? const Color(IColors.yellow)
                  : message == null
                      ? widget.color ?? Colors.transparent
                      : const Color(IColors.red),
              width: !hasFocus && message == null ? 1 : 0.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          height: 48,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: widget.node,
                  controller: widget.controller,
                  obscureText: obscured,
                  keyboardType: widget.inputType,
                  inputFormatters: widget.formatters ?? [],
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                      hintText: widget.hint ?? "",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: const Color(IColors.hintColor)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                  onChanged: (v) {
                    if (widget.validate?.call(v) != null) {
                      setState(() {
                        message = widget.validate?.call(v);
                      });
                    } else {
                      setState(() {
                        message = null;
                      });
                    }
                  },
                ),
              ),
              !obscured
                  ? widget.suffix ?? const SizedBox()
                  : widget.obscuredSuffix ?? const SizedBox()
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: message != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(IColors.lightRed)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_sharp,
                        color: Color(IColors.red),
                        size: 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          message ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: const Color(IColors.red),
                                  fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        )
      ],
    );
  }
}

class TextFieldButton extends StatelessWidget {
  final String? hint;
  final Color? color;
  final String? searchKey;
  final EdgeInsets? padding;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  const TextFieldButton({
    Key? key,
    this.hint,
    this.color,
    this.padding,
    required this.onTap,
    this.searchKey,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (searchKey == null) {
          onTap();
        }
      },
      child: Container(
        padding: padding ??
            const EdgeInsets.only(left: 16, right: 14, top: 15, bottom: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? Colors.transparent,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: searchKey != null
                    ? const Color(0xFFFFF8EA)
                    : Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Text(
                    searchKey == null ? hint ?? "" : searchKey!,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: const Color(IColors.textLightBlack),
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  if (searchKey != null) ...{
                    GestureDetector(
                      onTap: () => onCancel?.call(),
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: Color(IColors.textLightBlack),
                      ),
                    ),
                  }
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
