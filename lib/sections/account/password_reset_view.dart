part of '../../main.dart';

class PasswordResetView extends StatelessWidget {
  PasswordResetView(this.showMessage);
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
                child: Text('Reset Your Password', style: Theme.of(context).textTheme.display1),
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
                      child: PasswordResetForm(showMessage)
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

class PasswordResetForm extends StatefulWidget {
  PasswordResetForm(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  PasswordResetFormState createState() {
    return PasswordResetFormState(showMessage);
  }
}

class PasswordResetFormState extends State<PasswordResetForm> {
  PasswordResetFormState(this.showMessage);
  final void Function(SnackBar) showMessage;

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'submitted': false,
    'username': null
  };

  TextEditingController _usernameController;
  FocusNode _usernameFocus;

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      this.setState(() {
        _formData['submitted'] = true;
      });

      var data = new UserPasswordReset();
      data.email_or_username = _formData['username'];

      stateStore.usersResetPassword(data).then((value) {
        this.setState(() {
          _formData['submitted'] = false;
        });
        stateStore.setHomeContentRoute(HomeContentRoute.shop);
        showMessage(SnackBar(content: Text('Please check your email')));
      }).catchError((e) {
        this.setState(() {
          _formData['submitted'] = false;
        });
        if (e is ApiException && (e as ApiException).code == 500) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('No matching account. Please sign up')));
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
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocus.dispose();
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
            _formData['submitted'] == false 
            ? RaisedButton(
              onPressed: () => _formSubmit(),
              child: Text('Reset password'),
            )
            : PasswordResetFormLoadingIndicator(),

            SizedBox (
              height: appGeneralSpacing
            ),
            RichText(
              text: TextSpan(
                text: 'Enter your username or email address and you\'ll receive an email with a link you need to click, in order to log in and change your password.',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordResetFormLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.usersResetPasswordFuture.status == FutureStatus.pending) {
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
