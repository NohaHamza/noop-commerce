part of '../../main.dart';

class CheckoutContent extends StatefulWidget {
  CheckoutContent(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  State<StatefulWidget> createState() => CheckoutContentState(showMessage);
}

class CheckoutContentState extends State<CheckoutContent> {
  CheckoutContentState(this.showMessage);
  final void Function(SnackBar) showMessage;

  CheckoutStepsView checkoutStepsView;

  @override
  initState() {
    checkoutStepsView = new CheckoutStepsView(showMessage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return stateStore.currentCheckoutContentRoute == CheckoutContentRoute.steps ? checkoutStepsView
    : Container();
  }
}
