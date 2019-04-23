part of '../../main.dart';

class LoginView extends StatelessWidget {
  LoginView(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Material(
              elevation: appViewHeaderElevation,
              child: Container (
                margin: Device.get().isIphoneX && MediaQuery.of(context).orientation == Orientation.landscape
                  ? const EdgeInsets.only(top: appTopMargin, left: appLeftMargin_iPhoneX, right: appRightMargin, bottom: appBottomMargin)
                  : const EdgeInsets.only(top: appTopMargin, left: appLeftMargin, right: appRightMargin, bottom: appBottomMargin),
                child: Text('Log in', style: Theme.of(context).textTheme.display1),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity),
                    child: Container (
                      margin: Device.get().isIphoneX && MediaQuery.of(context).orientation == Orientation.landscape
                        ? const EdgeInsets.only(top: appTopMargin, left: appLeftMargin_iPhoneX, right: appRightMargin, bottom: appBottomMargin)
                        : const EdgeInsets.only(top: appTopMargin, left: appLeftMargin, right: appRightMargin, bottom: appBottomMargin),
                      child: LoginForm(showMessage)
                    )
                  ),

               ]
              )
            )
          ),
        ],
      )
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  LoginFormState createState() {
    return LoginFormState(showMessage);
  }
}

class LoginFormState extends State<LoginForm> {
  LoginFormState(this.showMessage);
  final void Function(SnackBar) showMessage;

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'submitted': false,
    'username': null,
    'password': null
  };

  TextEditingController _usernameController;
  FocusNode _usernameFocus;
  TextEditingController _passwordController;
  FocusNode _passwordFocus;

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      this.setState(() {
        _formData['submitted'] = true;
      });

      var data = new UserPasswordCheck();
      data.email_or_username = _formData['username'];
      data.password = _formData['password'];

      stateStore.usersCheckPassword(data).then((value) {
        this.setState(() {
          _formData['submitted'] = false;
        });
        
        var currentUser = stateStore.userList.firstWhere((user) => 
          user.username == data.email_or_username.toLowerCase() 
          || user.email == data.email_or_username.toLowerCase(), 
          orElse: () => null);
        stateStore.setCurrentUser(currentUser);
        if (stateStore.gotoCheckout) {
          stateStore.setCheckoutContentRoute(CheckoutContentRoute.steps);
          stateStore.setGotoCheckout(false);
        } else {
          stateStore.setHomeContentRoute(HomeContentRoute.shop);
        }
        showMessage(SnackBar(content: Text('Successfully logged in')));
      }).catchError((e) {
        this.setState(() {
          _formData['submitted'] = false;
        });
        if (e is ApiException && ((e as ApiException).code == 400 || (e as ApiException).code == 500)) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials. Please try again')));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something unexpected happened! Please try again')));
        }
      });
    }
  }

  @override
  initState() {
    super.initState();
    _usernameController = new TextEditingController();
    _usernameFocus = new FocusNode();
    _passwordController = new TextEditingController();
    _passwordFocus = new FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: MediaQuery.of(context).orientation == Orientation.portrait
          ? const EdgeInsets.only(top: appGeneralSpacing, left: appGeneralSpacing, right: appGeneralSpacing, bottom: appGeneralSpacing)
          : const EdgeInsets.only(top: appGeneralSpacing, left: appGeneralSpacing * 10, right: appGeneralSpacing * 10, bottom: appGeneralSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: _usernameController,
              focusNode: _usernameFocus,
              onSaved: (value) {
                _formData['username'] = value;
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'Username or email address',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
              },
            ),
            SizedBox (
              height: appGeneralSpacing
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: _passwordController,
              focusNode: _passwordFocus,
              onSaved: (value) {
                _formData['password'] = value;
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
              },
            ),
            SizedBox (
              height: appGeneralSpacing
            ),
            _formData['submitted'] == false 
            ? RaisedButton(
              onPressed: () => _formSubmit(),
              child: Text('Log in'),
            )
            : LoginFormLoadingIndicator(),

            SizedBox (
              height: appGeneralSpacing
            ),
            RichText(
              text: TextSpan(
                text: 'If you don\'t have an account you can ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'sign up', style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: new TapGestureRecognizer()..onTap = () => stateStore.setAccountContentRoute(AccountContentRoute.signup),
                  ),
                  TextSpan(text: ' for one now.'),
                ],
              ),
            ),
            SizedBox (
              height: appGeneralSpacing
            ),
            RichText(
              text: TextSpan(
                text: 'You can also ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'reset your password', style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: new TapGestureRecognizer()..onTap = () => stateStore.setAccountContentRoute(AccountContentRoute.passwordReset),
                  ),
                  TextSpan(text: ' if you\'ve forgotten it.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginFormLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.usersCheckPasswordFuture.status == FutureStatus.pending) {
        return Column(
          children: [
            SizedBox (
              height: appGeneralSpacing
            ),
            AppProgressIndicator(),
          ]
        );
      }
      return Container();
    }
  );
}
