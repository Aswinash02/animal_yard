import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

import 'lang_text.dart';

class Loading {
  static BuildContext? _buildContext;
  static late BuildContext _context;

  static setInstance(BuildContext context) {
    _buildContext = context;
  }

  static getInstance() => Loading._buildContext;

  Future show() async {
    return showDialog(
      context: Loading._buildContext!,
      builder: (BuildContext context) {
        Loading._context = context;
        return AlertDialog(
            content: Row(
          children: [
            CircularProgressIndicator(),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 180,
                child: Text(LangText(context).local.please_wait_ucf)),
          ],
        ));
      },
    );
  }

  hide() {
    Navigator.of(Loading._context).pop();
  }

  static Widget bottomLoading(bool value) {
    return value
        ? Container(
            alignment: Alignment.center,
            child: SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator()),
          )
        : SizedBox(
            height: 5,
            width: 5,
          );
  }
}

class OneContextLoading {
  static late BuildContext _loadingContext;

  static show() async {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        _loadingContext = context;
        return AlertDialog(
            content: Row(
          children: [
            CircularProgressIndicator(),
            const SizedBox(
              width: 10,
            ),
            Text(LangText(context).local.please_wait_ucf),
          ],
        ));
      },
    );
  }

  static hide() {
    Navigator.of(_loadingContext).pop();
  }
}
