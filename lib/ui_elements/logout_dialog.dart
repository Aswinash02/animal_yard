import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text('Log Out'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to log out?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: MyTheme.accent_color),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Log Out',
              style: TextStyle(color: MyTheme.accent_color),
            ),
            onPressed: () {
              // Close any open dialogs/popups
              Navigator.of(context).pop();

              // Clear user data
              AuthHelper().clearUserData();

              // Navigate to the Login screen and then show the SnackBar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              ).then((_) {
                // This callback is executed after navigation completes
                final snackBar = SnackBar(
                  content: Text('Logout Successfully!'),
                  backgroundColor: MyTheme.accent_color,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
          ),
        ],
      );
    },
  );
}
