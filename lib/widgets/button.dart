import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vaaka_device/widgets/theme.dart';

class BaseButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPress;
  final bool disabled;
  final Color _disabledColor = Colors.grey;
  final double maxWidth;

  const BaseButton({Key key, @required this.text, @required this.color, @required this.onPress, this.disabled = false, this.maxWidth = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (disabled) {
          return;
        }

        onPress();
      },
      child: Container(
        width: maxWidth,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
          color: disabled ? _disabledColor : color,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: disabled ? _disabledColor.withOpacity(0.37) : color.withOpacity(0.37),
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
