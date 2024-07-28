import 'package:prayer_app/view/home/nav_bar_screens/quran/core/utils/font_manager.dart';

import '../../../core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../text_custom/text_custom.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  final IconData? iconData;
  final String? text;
  final Function? onPressed;
  final List<Widget>? actions;
  final bool? isNull;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? centerTitle;
  final Widget? widget;
  final Color? textColor;
  final Color? iconColor;
  final Brightness? brightness;
  const AppBarCustom({
    Key? key,
    this.iconData = Icons.arrow_back_rounded,
    this.text = '',
    this.widget,
    this.onPressed,
    this.isNull = true,
    this.centerTitle = true,
    this.textAlign = TextAlign.center,
    this.fontSize = FontSize.s12 * 2,
    this.fontWeight = FontWeight.w600,
    this.brightness = Brightness.dark,
    this.textColor = ColorManager.black,
    this.iconColor = ColorManager.primary,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      centerTitle: centerTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        // statusBarIconBrightness: brightness,
        statusBarColor: Colors.blue[900],
      ),
      leading: isNull!
          ? IconButton(
              onPressed: () {
                onPressed == null ? null : onPressed!();
                Navigator.pop(context);
              },
              icon: Icon(
                iconData,
                color: Colors.black,
              ),
            )
          : widget,
      title: TextCustom(
        textAlign: textAlign!,
        text: text!,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
      ),
      actions: actions,
    );
  }
}
