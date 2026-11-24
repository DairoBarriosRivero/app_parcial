import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn? _googleSignInInstance;

  // Instanciación perezosa (lazy) de GoogleSignIn para evitar errores de inicialización en Web
  GoogleSignIn get _googleSignIn => _googleSignInInstance ??= GoogleSignIn();

  // Usuario actual y stream de cambios en el estado de autenticación
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Inicio de sesión con correo electrónico y contraseña
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  /// Registro de usuario con correo, contraseña y nombre completo
  Future<UserCredential> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Actualizar el nombre completo del usuario
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name.trim());
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado al registrar usuario: $e');
    }
  }

  /// Recuperar contraseña mediante correo electrónico
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error al enviar correo de recuperación: $e');
    }
  }

  /// Inicio de sesión con Google (compatible tanto con Web como con Móvil)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // En Web, Firebase Auth maneja el flujo oficial directamente con un Popup emergente
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // En Android e iOS, utilizamos el SDK nativo de Google Sign-In
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // El usuario canceló la selección de cuenta
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  /// Inicio de sesión con Facebook (compatible con Web y Móvil)
  Future<UserCredential?> signInWithFacebook() async {
    try {
      if (kIsWeb) {
        // En Web, utilizamos public_profile que está garantizado por defecto en Meta
        final FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('public_profile');
        return await _auth.signInWithPopup(facebookProvider);
      } else {
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['public_profile'],
        );

        if (result.status == LoginStatus.success) {
          final AccessToken? accessToken = result.accessToken;
          if (accessToken == null) {
            throw Exception('No se pudo obtener el token de acceso de Facebook.');
          }

          final OAuthCredential credential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          return await _auth.signInWithCredential(credential);
        } else if (result.status == LoginStatus.cancelled) {
          // El usuario canceló la autenticación
          return null;
        } else {
          throw Exception(
              result.message ?? 'Error en la autenticación con Facebook.');
        }
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error al iniciar sesión con Facebook: $e');
    }
  }

  /// Cierre de sesión de Firebase, Google y Facebook
  Future<void> signOut() async {
    try {
      // Cerrar sesión en Firebase
      await _auth.signOut();

      // En móviles, limpiar también las sesiones de los SDK nativos
      if (!kIsWeb) {
        if (_googleSignInInstance != null &&
            await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
        }
        await FacebookAuth.instance.logOut();
      }
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  /// Manejo y traducción de códigos de error de Firebase Authentication
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe un usuario registrado con este correo.';
      case 'wrong-password':
        return 'La contraseña ingresada es incorrecta.';
      case 'invalid-credential':
        return 'Credenciales inválidas. Verifica tu correo y contraseña.';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está registrado.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña es muy débil. Debe tener al menos 6 caracteres.';
      case 'user-disabled':
        return 'Esta cuenta ha sido inhabilitada por un administrador.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Inténtalo de nuevo más tarde.';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu conexión a internet.';
      case 'operation-not-allowed':
        return 'Este método de autenticación no está habilitado en Firebase Console.';
      case 'popup-closed-by-user':
        return 'Ventana de inicio de sesión cerrada por el usuario.';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con el mismo correo pero diferente método de acceso.';
      default:
        return e.message ?? 'Ocurrió un error de autenticación (${e.code}).';
    }
  }
}
