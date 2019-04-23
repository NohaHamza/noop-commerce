part of '../../main.dart';

class SignupView extends StatelessWidget {
  SignupView(this.showMessage);
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
                child: Text('Sign up', style: Theme.of(context).textTheme.display1),
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
                      child: SignupForm(showMessage)
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

class SignupForm extends StatefulWidget {
  SignupForm(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  SignupFormState createState() {
    return SignupFormState(showMessage);
  }
}

class SignupFormState extends State<SignupForm> {
  SignupFormState(this.showMessage);
  final void Function(SnackBar) showMessage;

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'submitted': false,
    'firstName': null,
    'lastName': null,
    'email': null,
    'password': null
  };

  TextEditingController _firstNameController;
  FocusNode _firstNameFocus;
  TextEditingController _lastNameController;
  FocusNode _lastNameFocus;
  TextEditingController _emailController;
  FocusNode _emailFocus;
  TextEditingController _passwordController;
  FocusNode _passwordFocus;

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      this.setState(() {
        _formData['submitted'] = true;
      });

      var data = new User();
      data.first_name = _formData['firstName'];
      data.last_name = _formData['lastName'];
      data.email = _formData['email'];
      data.password = _formData['password'];

      data.username = data.email.toLowerCase();
      data.is_superuser = false;
      data.is_staff = false;
      data.is_active = false;
      data.last_login = new DateTime.now();
      data.date_joined = new DateTime.now();

      stateStore.usersCreate(data).then((value) {
        this.setState(() {
          _formData['submitted'] = false;
        });
        // After sign up, no need to do a server round-trip to reload the users: Just add the new user to the list
        stateStore.userList.add(data);
        stateStore.setHomeContentRoute(HomeContentRoute.shop);
        showMessage(SnackBar(content: Text('Please check your email')));
      }).catchError((e) {
        this.setState(() {
          _formData['submitted'] = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something unexpected happened! Please try again')));
      });
    }
  }

  @override
  initState() {
    super.initState();
    _firstNameController = new TextEditingController();
    _firstNameFocus = new FocusNode();
    _lastNameController = new TextEditingController();
    _lastNameFocus = new FocusNode();
    _emailController = new TextEditingController();
    _emailFocus = new FocusNode();
    _passwordController = new TextEditingController();
    _passwordFocus = new FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameFocus.dispose();
    _lastNameController.dispose();
    _lastNameFocus.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
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
              controller: _firstNameController,
              focusNode: _firstNameFocus,
              onSaved: (value) {
                _formData['firstName'] = value;
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'First name',
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
              controller: _lastNameController,
              focusNode: _lastNameFocus,
              onSaved: (value) {
                _formData['lastName'] = value;
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'Last name',
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              controller: _emailController,
              focusNode: _emailFocus,
              onSaved: (value) {
                _formData['email'] = value;
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'Email',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                } else if (!EmailValidator.validate(value)) {
                  return 'Must be valid';
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
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
              },
            ),
            SizedBox (
              height: appGeneralSpacing
            ),
            _formData['submitted'] == false 
            ? RaisedButton(
              onPressed: () => _formSubmit(),
              child: Text('Sign up'),
            )
            : SignupFormLoadingIndicator(),

            SizedBox (
              height: appGeneralSpacing
            ),
            RichText(
              text: TextSpan(
                text: 'After signing up, you\'ll receive an email with a link you need to click, in order to activate your account.',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupFormLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.usersCreateFuture.status == FutureStatus.pending) {
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
