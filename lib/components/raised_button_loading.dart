import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RaisedButtonLoading extends HookWidget {
  final Color color;
  final AsyncCallback onPressed;
  final Widget child;

  const RaisedButtonLoading({
    Key key,
    this.color,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    return RaisedButton(
      color: color,
      onPressed: () async {
        loading.value = true;
        await onPressed();
        loading.value = false;
      },
      child: Stack(alignment: Alignment.center, children: [
        if (loading.value) loadingIndicator(),
        Opacity(opacity: loading.value ? 0 : 1, child: child)
      ]),
    );
  }

  Widget loadingIndicator() {
    return const SizedBox(
      height: 15,
      width: 15,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
