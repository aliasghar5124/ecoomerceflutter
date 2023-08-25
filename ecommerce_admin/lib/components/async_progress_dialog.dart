import 'package:flutter/material.dart';
const _DefaultDecoration = BoxDecoration(
  color: Colors.white,
  shape: BoxShape.rectangle,
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class AsyncProgressDialog extends StatefulWidget {
  @required
  final Future future;
  final BoxDecoration decoration;
  final double opacity;
  final Widget progress;
  final Widget message;
  final Function onError;

  AsyncProgressDialog(
    this.future, {
    this.decoration,
    this.opacity = 1.0,
    this.progress,
    this.message,
    this.onError,
  });

  @override
  State<AsyncProgressDialog> createState() => _AsyncProgressDialogState();
}

class _AsyncProgressDialogState extends State<AsyncProgressDialog> {
  @override
  void initState() {
    widget.future.then((val) {
      Navigator.of(context).pop(val);
    }).catchError((e) {
      Navigator.of(context).pop();
      if (widget.onError != null) {
        widget.onError.call(e);
      } else {
        throw e;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _buildDialog(context),
      onWillPop: () {
        return Future(() {
          return false;
        });
      },
    );
  }

  Widget _buildDialog(BuildContext context) {
    var content;
    if (widget.message == null) {
      content = Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: widget.decoration ?? _DefaultDecoration,
          child: widget.progress ?? CircularProgressIndicator(),
        ),
      );
    } else {
      content = Container(
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: widget.decoration ?? _DefaultDecoration,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          widget.progress ?? CircularProgressIndicator(),
          SizedBox(width: 20),
          _buildText(context)
        ]),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Opacity(
        opacity: widget.opacity,
        child: content,
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    if (widget.message == null) {
      return SizedBox.shrink();
    }
    return Expanded(
      flex: 1,
      child: widget.message,
    );
  }
}
