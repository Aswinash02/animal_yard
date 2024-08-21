import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 150,
                width: 150,
                child: Image.asset("assets/splash_screen_logo.png")),
            SizedBox(
              height: 20,
            ),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                context.push('/');
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
