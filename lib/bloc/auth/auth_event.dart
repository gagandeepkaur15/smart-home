abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin(this.email, this.password);
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String displayName;


  AuthSignUp(this.email, this.password, this.displayName);
}

class AuthLogout extends AuthEvent {}