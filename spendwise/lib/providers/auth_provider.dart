import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    checkCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkCurrentUser() async {
    final currentUser = HiveService.getCurrentUser();
    if (currentUser != null) {
      state = state.copyWith(user: currentUser, isLoading: false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = userCredential.user!;
      final appUser = AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email!,
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );
      
      await HiveService.saveUser(appUser);
      state = state.copyWith(user: appUser, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await userCredential.user!.updateDisplayName(name);
      
      final appUser = AppUser(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      await HiveService.saveUser(appUser);
      state = state.copyWith(user: appUser, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await HiveService.clearUser();
    state = AuthState();
  }

  Future<void> updateUser(AppUser user) async {
    await HiveService.updateUser(user);
    state = state.copyWith(user: user);
  }
}