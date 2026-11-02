import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Đăng nhập bằng Email & Mật khẩu
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Đăng ký bằng Email & Mật khẩu
  Future<UserCredential> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName != null && displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
      await cred.user?.reload();
    }
    return cred;
  }

  // Đăng nhập Google
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // Người dùng hủy chọn tài khoản

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  // Đăng nhập Ẩn danh (Dùng thử không cần tài khoản)
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // Gửi email đặt lại mật khẩu
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // Đăng xuất
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  // Dịch mã lỗi Firebase Auth sang tiếng Việt dễ hiểu
  static String getAuthErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Không tìm thấy tài khoản với email này.';
        case 'wrong-password':
          return 'Mật khẩu không chính xác.';
        case 'invalid-credential':
          return 'Thông tin đăng nhập không chính xác hoặc đã hết hạn.';
        case 'email-already-in-use':
          return 'Email này đã được sử dụng cho tài khoản khác.';
        case 'invalid-email':
          return 'Địa chỉ email không đúng định dạng.';
        case 'weak-password':
          return 'Mật khẩu quá yếu, vui lòng nhập tối thiểu 6 ký tự.';
        case 'operation-not-allowed':
          return 'Phương thức đăng nhập này chưa được kích hoạt trên Firebase Console.';
        case 'user-disabled':
          return 'Tài khoản này đã bị khóa.';
        case 'too-many-requests':
          return 'Quá nhiều lần thử thất bại. Vui lòng thử lại sau ít phút.';
        case 'network-request-failed':
          return 'Lỗi kết nối mạng. Vui lòng kiểm tra lại đường truyền internet.';
        default:
          return error.message ?? 'Đã xảy ra lỗi xác thực (${error.code}).';
      }
    }
    return error.toString();
  }
}
