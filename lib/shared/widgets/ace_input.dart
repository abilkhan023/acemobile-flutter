import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../core/utils/l10n.dart';
import '../../core/utils/validators.dart';
import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_icon.dart';

class AceInput extends StatefulWidget {
  const AceInput({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.rules = const [],
    this.type = 'text',
    this.mask,
    this.icon,
    this.onIcon,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? label;
  final String? placeholder;
  final List<String> rules;
  final String type;
  final String? mask;
  final String? icon;
  final VoidCallback? onIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool enabled;
  final TextInputAction? textInputAction;

  @override
  State<AceInput> createState() => _AceInputState();
}

class _AceInputState extends State<AceInput> {
  late final TextEditingController _controller = widget.controller ?? TextEditingController();
  final _focus = FocusNode();
  bool _visiblePassword = false;

  bool get _isPassword => widget.type == 'password';
  bool get _isNumber => widget.type == 'number' || rulesHaveNumber(widget.rules);
  bool get _isText => widget.type == 'text' || widget.type.isEmpty;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _controller.text.isNotEmpty;
    final showClear = hasValue && _isText;
    final trailingIcon = showClear ? 'x-circle' : widget.icon;
    final hasTrailing = trailingIcon != null || _isPassword;
    final formatters = <TextInputFormatter>[
      if (widget.mask != null && widget.mask!.isNotEmpty) MaskTextInputFormatter(mask: widget.mask),
    ];

    return FormField<String>(
      initialValue: _controller.text,
      validator: widget.rules.isEmpty ? null : aceValidator(context, widget.rules, isNumber: _isNumber),
      builder: (field) {
        final error = widget.errorText?.isNotEmpty == true ? widget.errorText : field.errorText;
        final filled = _focus.hasFocus || hasValue;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            if (widget.label != null) Text(widget.label!, style: AceText.label),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  obscureText: _isPassword && !_visiblePassword,
                  keyboardType: _isNumber ? const TextInputType.numberWithOptions(decimal: true) : (widget.rules.contains('email') ? TextInputType.emailAddress : TextInputType.text),
                  textInputAction: widget.textInputAction,
                  inputFormatters: formatters,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: AceText.style(size: 14),
                  cursorColor: AceColors.white,
                  onChanged: (v) {
                    field.didChange(v);
                    widget.onChanged?.call(v);
                  },
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: filled ? AceColors.fillFocused : Colors.transparent,
                    hintText: widget.placeholder ?? context.l10n.enterData,
                    hintStyle: AceText.style(size: 14, color: AceColors.muted),
                    contentPadding: EdgeInsets.fromLTRB(24, 20, hasTrailing ? 42 : 24, 20),
                    enabledBorder: _border(error != null ? AceColors.accent : AceColors.border),
                    focusedBorder: _border(error != null ? AceColors.accent : AceColors.border),
                    disabledBorder: _border(AceColors.border),
                    border: _border(AceColors.border),
                  ),
                ),
                if (hasTrailing)
                  Positioned(
                    right: 24,
                    child: Opacity(
                      opacity: 0.7,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (_isPassword) {
                            setState(() => _visiblePassword = !_visiblePassword);
                          } else if (showClear) {
                            _controller.clear();
                            field.didChange('');
                            widget.onChanged?.call('');
                          } else {
                            widget.onIcon?.call();
                          }
                        },
                        child: AceIcon(_isPassword ? (_visiblePassword ? 'eye-close' : 'eye') : trailingIcon!),
                      ),
                    ),
                  ),
              ],
            ),
            if (error != null) Text(error, style: AceText.style(size: 12, color: AceColors.accent)),
          ],
        );
      },
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color),
      );
}
