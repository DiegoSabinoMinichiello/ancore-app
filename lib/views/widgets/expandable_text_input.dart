import 'package:flutter/material.dart';

class ExpandableTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onSubmitted;
  final ValueChanged<bool>? onFocusChanged;

  const ExpandableTextInput({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onFocusChanged,
  });

  @override
  ExpandableTextInputState createState() => ExpandableTextInputState();
}

class ExpandableTextInputState extends State<ExpandableTextInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void requestFocus() {
    _focusNode.requestFocus();
  }

  void _handleFocusChange() {
    final hasFocus = _focusNode.hasFocus;
    setState(() {
      _isFocused = hasFocus;
    });
    widget.onFocusChanged?.call(hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _effectiveController,
              focusNode: _focusNode,
              expands: true,
              minLines: null,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => widget.onSubmitted?.call(),
              decoration: InputDecoration(
                hintText: 'Escreva com suas palavras...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: widget.onSubmitted,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
