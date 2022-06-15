import 'package:bebeautyapp/repo/services/authentication_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordFunction {
  final AuthenticationServices _auth = AuthenticationServices();

  Future<void> sendEmailResetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email);
    Fluttertoast.showToast(msg: 'A password reset link has been sent to ${email}', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
  }
}