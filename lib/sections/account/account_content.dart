part of '../../main.dart';

class AccountContent extends StatefulWidget {
  AccountContent(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  State<StatefulWidget> createState() => AccountContentState(showMessage);
}

class AccountContentState extends State<AccountContent> {
  AccountContentState(this.showMessage);
  final void Function(SnackBar) showMessage;

  LoginView loginView;
  SignupView signupView;
  ActivateAccountView activateAccountView;
  PasswordResetView passwordResetView;

  @override
  initState() {
    loginView = new LoginView(showMessage);
    signupView = new SignupView(showMessage);
    // @todo:
    // activateAccountView = new ActivateAccountView(showMessage);
    passwordResetView = new PasswordResetView(showMessage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return stateStore.currentAccountContentRoute == AccountContentRoute.login ? loginView
    : stateStore.currentAccountContentRoute == AccountContentRoute.signup ? signupView
    : stateStore.currentAccountContentRoute == AccountContentRoute.activateAccount ? activateAccountView
    : stateStore.currentAccountContentRoute == AccountContentRoute.passwordReset ? passwordResetView
    : Container();
  }
}
