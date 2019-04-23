part of '../main.dart';

class CartDrawer extends StatelessWidget {
  void _confirmRemoveDialog(BuildContext context, CartItem cartItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text('Remove this item?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Yes', style: TextStyle(color: primaryTextColour)),
              onPressed: () {
                stateStore.removeCartItem(cartItem);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Cancel', style: TextStyle(color: primaryTextColour)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.fetchSystemSettingsFuture == FutureStatus.pending) {
        return AppProgressIndicator();
      }

      var checkoutAccountRequired = false;
      final SystemSetting systemSettingCheckoutAccountRequired = 
        stateStore.systemSettingList.firstWhere((systemSetting) => systemSetting.name == 'SHOP_CHECKOUT_ACCOUNT_REQUIRED', orElse: () => null);
      if (systemSettingCheckoutAccountRequired != null) {
        checkoutAccountRequired = systemSettingCheckoutAccountRequired.value.toLowerCase() == 'true';
      }
      // Settings (set in Mezzanine admin) override system settings (set in memory / config)
      final Setting settingCheckoutAccountRequired = 
        stateStore.settingList.firstWhere((setting) => setting.name == 'SHOP_CHECKOUT_ACCOUNT_REQUIRED', orElse: () => null);
      if (settingCheckoutAccountRequired != null) {
        checkoutAccountRequired = settingCheckoutAccountRequired.value.toLowerCase() == 'true';
      }

      SystemSetting shopCurrencySetting = stateStore.systemSettingList.firstWhere((systemSetting) => systemSetting.name == 'SHOP_CURRENCY_LOCALE', orElse: () => null);
      NumberFormat shopCurrencyFormat = new NumberFormat.compact();
      String shopCurrencySymbol = '\$';
      if (shopCurrencySetting != null) {
        shopCurrencyFormat = new NumberFormat('#,##0.00', shopCurrencySetting.value);
        shopCurrencySymbol = (shopCurrencySetting.value == 'en_US.UTF-8' || shopCurrencySetting.value == 'en_AU.UTF-8') 
          ? '\$' 
          : shopCurrencySetting.value == 'en_GB.UTF-8' 
          ? '£' 
          : shopCurrencySetting.value == 'af_ZA.UTF-8' 
          ? 'R' 
          : shopCurrencyFormat.currencySymbol;
      }

      List<Widget> cartWidgetList = [];
      stateStore.cart.sort((a, b) => a.description.compareTo(b.description));
      var cartTotal = 0.0;
      stateStore.cart.forEach((cartItem) {
        cartTotal += double.parse(cartItem.total_price);
        var cartItemWidget = ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(cartItem.description,
                style: Theme.of(context).textTheme.body2,
                softWrap: true,
                overflow: TextOverflow.fade,
              )),
              Text(
                cartItem.quantity.toString() + ' x ' + shopCurrencySymbol + ' ' 
                + shopCurrencyFormat.format(double.parse(cartItem.unit_price)), 
                // + '     ' + shopCurrencySymbol + ' ' + shopCurrencyFormat.format(double.parse(cartItem.total_price)),
                style: Theme.of(context).textTheme.body1,
              ),
            ]
          ),
          trailing: GestureDetector(
            child: Icon(Icons.delete),
            onTap: () {
              _confirmRemoveDialog(context, cartItem);
            }
          ),
          enabled: false,
        );
        cartWidgetList.add(cartItemWidget);
      });

      if (stateStore.cart.length == 0) {
        var cartItemWidget = Text('No items in cart.');
        cartWidgetList.add(cartItemWidget);
      } else {
        String totalText = shopCurrencySymbol + ' ' + shopCurrencyFormat.format(cartTotal);
        var cartItemWidget = ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total',
                style: Theme.of(context).textTheme.body2
              ),
              Text(
                shopCurrencySymbol + ' ' + shopCurrencyFormat.format(cartTotal),
                style: Theme.of(context).textTheme.body2,
              ),
            ]
          ),
          trailing: Icon(Icons.shopping_cart, color: Colors.transparent),
          enabled: false,
        );
        cartWidgetList.add(cartItemWidget);
      }

      return Drawer(
        child: Column(
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
                  child: Text('Cart', style: Theme.of(context).textTheme.display1),
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
                          : const EdgeInsets.only(top: appTopMargin, left: appLeftMargin, right: appRightMargin, bottom: appBottomMargin * 5),
                        child: Column(
                          children: [
                            Column (
                              children: cartWidgetList,
                            ),
                            stateStore.cart.length != 0 && checkoutAccountRequired && !stateStore.isLoggedIn
                            ? Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'You must be logged in to check out.',
                                    style: DefaultTextStyle.of(context).style,
                                  ),
                                ),
                                SizedBox (
                                  height: appGeneralSpacing
                                ),
                                RaisedButton(
                                  child: const Text('Log in or Create Account'),
                                  onPressed: () {
                                    stateStore.setGotoCheckout(true);
                                    stateStore.setAccountContentRoute(AccountContentRoute.login);
                                    Navigator.pop(context);
                                  }
                                ),
                              ]
                            )
                            : stateStore.cart.length != 0
                            ? RaisedButton(
                              child: const Text('Proceed to Checkout'),
                              onPressed: () {
                                stateStore.setCheckoutContentRoute(CheckoutContentRoute.steps);
                                Navigator.pop(context);
                              }
                            )
                            : Container()
                          ]
                        )
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
  );
}
