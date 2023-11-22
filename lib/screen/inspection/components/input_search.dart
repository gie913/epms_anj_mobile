import 'package:epms/base/constants/enum.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  const InputSearch({
    super.key,
    this.controller,
    this.enabled = true,
    this.hintText = 'Pencarian',
    this.inputStyle = InputStyle.outline,
    this.labelText,
    this.margin,
    this.onChanged,
    this.onTapSuffixIcon,
    this.readOnly = false,
    this.validatorText = '',
    this.useSuffixIcon = true,
  });

  final TextEditingController? controller;
  final bool enabled;
  final String hintText;
  final InputStyle inputStyle;
  final String? labelText;
  final EdgeInsets? margin;
  final Function(String)? onChanged;
  final Function()? onTapSuffixIcon;
  final bool readOnly;
  final String validatorText;
  final bool useSuffixIcon;

  @override
  Widget build(BuildContext context) {
    return InputPrimary(
      controller: controller,
      enabled: enabled,
      hintText: hintText,
      labelText: labelText,
      margin: margin,
      onTapSuffixIcon: onTapSuffixIcon,
      onChanged: onChanged,
      preffixIcon: Icons.search,
      readOnly: readOnly,
      suffixIcon: useSuffixIcon ? Icons.cancel : null,
      validator: (value) => null,
      validatorText: validatorText,
    );
  }
}
