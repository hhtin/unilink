import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/pages/main_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_otp_page.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';

class Authentication {
  static Future<User> signInWithGoogle(
      {@required BuildContext context, bool isSignIn = true}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        // if (isSignIn)
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     Authentication.customSnackBar(
        //       content: 'Sign in successfully !',
        //     ),
        //   );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        // handle the error here
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
      return user;
    }
  }

  static Future<void> signOut(
      {@required BuildContext context, bool isShowToast = true}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      // if (isShowToast)
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     Authentication.customSnackBar(
      //       content: 'Sign out successfully !',
      //     ),
      //   );
    } catch (e) {
      if (isShowToast)
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error signing out. Try again.',
          ),
        );
    }
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Info,
      content: Text(
        content,
        style: TextStyle(color: Colors.black87, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signInWithPhone(BuildContext context,
      {String nationalCode = "+84", String phone = ""}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    Spinner.blockUiWithSpinnerScreen(context);
    return FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${nationalCode} ${phone}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("VerificationComplete: $credential");
          if (credential != null) {
            auth.signInWithCredential(credential).then((user) {
              if (user != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  Authentication.customSnackBar(
                    content: 'Sign in successfully',
                  ),
                );
                Navigator.of(context).pushNamed(MAIN_ROUTE);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  Authentication.customSnackBar(
                    content: 'Have error with register credential, try again !',
                  ),
                );
              }
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          Navigator.of(context).pop();
          print("VerificationFailed: ${e}");
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content: 'invalid phone number, try again !',
              ),
            );
          }
        },
        codeSent: (String verificationId, int resentToken) async {
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => RegisterByPhoneInputOTPPage(
                      verificationId: verificationId)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
    // codeAutoRetrievalTimeout: (String verificationId) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     Authentication.customSnackBar(
    //       content: 'Resend code after timeout waiting SMS !',
    //     ),
    //   );
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (_) => RegisterByPhoneInputOTPPage(
    //               verificationId: verificationId)));
    // });
  }

  static Future<User> confirmSms(String verificationId, String smsCode) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    User user;
    try {
      user = await (FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => value.user));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      user = null;
    }
    return user;
  }
}
