import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          debugPrint('Apple Sign-In Start');
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          // Debugging info
          print('Email: ${credential.email}');
          print('Full Name: ${credential.familyName} ${credential.givenName}');
          print('User Identifier: ${credential.userIdentifier}');
          print('Identity Token: ${credential.identityToken}');
          print('Authorization Code: ${credential.authorizationCode}');

          // Perform backend authentication here
        } catch (error) {
          // Handle errors (e.g., user cancels sign-in or AppleID not set up)
          print('Apple Sign-In Error: $error');
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.apple,
              size: 24,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Apple로 로그인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
