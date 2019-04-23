part of '../../main.dart';

class ActivateAccountView extends StatelessWidget {
  ActivateAccountView(this.showMessage);
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
                child: Text('Account Successfully Activated', style: Theme.of(context).textTheme.display1),
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
                      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
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
