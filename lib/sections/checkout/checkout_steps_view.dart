part of '../../main.dart';

class CheckoutStepsView extends StatelessWidget {
  CheckoutStepsView(this.showMessage);
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
                child: Text('Checkout', style: Theme.of(context).textTheme.display1),
              ),
            ),
          ),

          Expanded(
            child: StepsDetail(showMessage)
          ),
        ],
      )
    );
  }
}

class StepsDetail extends StatefulWidget {
  StepsDetail(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  StepsDetailState createState() {
    return StepsDetailState(showMessage);
  }
}

class StepsDetailState extends State<StepsDetail> {
  StepsDetailState(this.showMessage);
  final void Function(SnackBar) showMessage;

  final _formKeyBilling = GlobalKey<FormState>();
  final _formKeyShipping = GlobalKey<FormState>();
  final _formKeyPayment = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'step': 0,
    'saved': false,
    'submitted': false,
    
    'billingFirstName': null,
    'billingLastName': null,
    'billingStreet': null,
    'billingCity': null,
    'billingState': null,
    'billingPostcode': null,
    'billingCountry': null,
    'billingPhone': null,
    'billingEmail': null,

    'sameBillingShipping': true,
    'shippingFirstName': null,
    'shippingLastName': null,
    'shippingStreet': null,
    'shippingCity': null,
    'shippingState': null,
    'shippingPostcode': null,
    'shippingCountry': null,
    'shippingPhone': null,

    'additionalInstructions': null,
    'discountCode': null,

    'cardName': null,
    'cardType': 'Mastercard',
    'cardNumber': null,
    'cardExpiryMonth': null,
    'cardExpiryYear': null,
    'cardCcv': null,
  };

  Map<String, String> _cardYears = Map();

  TextEditingController _billingFirstNameController;
  FocusNode _billingFirstNameFocus;
  TextEditingController _billingLastNameController;
  FocusNode _billingLastNameFocus;
  TextEditingController _billingStreetController;
  FocusNode _billingStreetFocus;
  TextEditingController _billingCityController;
  FocusNode _billingCityFocus;
  TextEditingController _billingStateController;
  FocusNode _billingStateFocus;
  TextEditingController _billingPostcodeController;
  FocusNode _billingPostcodeFocus;
  GlobalKey<DropdownWidgetState> _billingCountryKey;
  TextEditingController _billingPhoneController;
  FocusNode _billingPhoneFocus;
  TextEditingController _billingEmailController;
  FocusNode _billingEmailFocus;

  TextEditingController _shippingFirstNameController;
  FocusNode _shippingFirstNameFocus;
  TextEditingController _shippingLastNameController;
  FocusNode _shippingLastNameFocus;
  TextEditingController _shippingStreetController;
  FocusNode _shippingStreetFocus;
  TextEditingController _shippingCityController;
  FocusNode _shippingCityFocus;
  TextEditingController _shippingStateController;
  FocusNode _shippingStateFocus;
  TextEditingController _shippingPostcodeController;
  FocusNode _shippingPostcodeFocus;
  GlobalKey<DropdownWidgetState> _shippingCountryKey;
  TextEditingController _shippingPhoneController;
  FocusNode _shippingPhoneFocus;

  TextEditingController _additionalInstructionsController;
  FocusNode _additionalInstructionsFocus;

  // @todo:
  TextEditingController _discountCodeController;
  FocusNode _discountCodeFocus;

  TextEditingController _cardNameController;
  FocusNode _cardNameFocus;
  TextEditingController _cardNumberController;
  FocusNode _cardNumberFocus;
  GlobalKey<DropdownWidgetState> _cardExpiryMonthKey;
  GlobalKey<DropdownWidgetState> _cardExpiryYearKey;
  TextEditingController _cardCcvController;
  FocusNode _cardCcvFocus;

  void _checkAndSetSameBillingShipping() {
    setState(() {
      if (_formData['sameBillingShipping']) {
        _formData['shippingFirstName'] = _formData['billingFirstName'];
        _formData['shippingLastName'] = _formData['billingLastName'];
        _formData['shippingStreet'] = _formData['billingStreet'];
        _formData['shippingCity'] = _formData['billingCity'];
        _formData['shippingState'] = _formData['billingState'];
        _formData['shippingPostcode'] = _formData['billingPostcode'];
        _formData['shippingCountry'] = _formData['billingCountry'];
        _formData['shippingPhone'] = _formData['billingPhone'];
      } else {
        _formData['shippingFirstName'] = '';
        _formData['shippingLastName'] = '';
        _formData['shippingStreet'] = '';
        _formData['shippingCity'] = '';
        _formData['shippingState'] = '';
        _formData['shippingPostcode'] = '';
        _formData['shippingCountry'] = null;
        _formData['shippingPhone'] = '';
      }

      _shippingFirstNameController.text = _formData['shippingFirstName'];
      _shippingLastNameController.text = _formData['shippingLastName'];
      _shippingStreetController.text = _formData['shippingStreet'];
      _shippingCityController.text = _formData['shippingCity'];
      _shippingStateController.text = _formData['shippingState'];
      _shippingPostcodeController.text = _formData['shippingPostcode'];
      if (_shippingCountryKey.currentState != null) {
        _shippingCountryKey.currentState.setValue(_formData['shippingCountry']);
      }
      _shippingPhoneController.text = _formData['shippingPhone'];
    });
  }

  void _stepChangeSave() {
    switch (_formData['step']) {
      case 0:
        _formKeyBilling.currentState.save();
        _formData['saved'] = true;
        _checkAndSetSameBillingShipping();
        break;
      case 1:
        _formKeyShipping.currentState.save();
        _formData['saved'] = true;
        break;
      case 2:
        _formKeyPayment.currentState.save();
        _formData['saved'] = true;
        break;
    }
  }

  void _orderCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank you for shopping with us!'),
          content: new Text('Your order is complete. We\'ve sent you a receipt via email.'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Okay', style: TextStyle(color: primaryTextColour)),
              onPressed: () {
                stateStore.clearCart();
                stateStore.setHomeContentRoute(HomeContentRoute.shop);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _createOrder(BuildContext context) {
    final SystemSetting settingShopCheckoutStepsSplit = stateStore.systemSettingList.firstWhere((setting) => setting.name == 'SHOP_CHECKOUT_STEPS_SPLIT', orElse: () => null);
    var shopCheckoutStepsSplit = false;
    if (settingShopCheckoutStepsSplit != null) {
      shopCheckoutStepsSplit = settingShopCheckoutStepsSplit.value.toLowerCase() == 'true';
    }
    final SystemSetting settingShopPaymentStepEnabled = stateStore.systemSettingList.firstWhere((setting) => setting.name == 'SHOP_PAYMENT_STEP_ENABLED', orElse: () => null);
    var shopPaymentStepEnabled = false;
    if (settingShopPaymentStepEnabled != null) {
      shopPaymentStepEnabled = settingShopPaymentStepEnabled.value.toLowerCase() == 'true';
    }
    final SystemSetting settingCheckoutStepConfirmation = stateStore.systemSettingList.firstWhere((setting) => setting.name == 'SHOP_CHECKOUT_STEPS_CONFIRMATION', orElse: () => null);
    var checkoutStepConfirmation = false;
    if (settingCheckoutStepConfirmation != null) {
      checkoutStepConfirmation = settingCheckoutStepConfirmation.value.toLowerCase() == 'true';
    }

    Cart cart = new Cart();
    cart.items = stateStore.cart;
    cart.last_updated = new DateTime.now();

    Order order = new Order();

    if (stateStore.isLoggedIn) {
      order.user_id = stateStore.currentUser.id;
    }

    order.key = 'TBC';
    order.site = Sites['Main'];
    order.shipping_type = ShippingType['Default'];
    order.status = OrderStatus['Unprocessed'];
    order.tax_type = '';

    order.billing_detail_first_name = _formData['billingFirstName'];
    order.billing_detail_last_name = _formData['billingLastName'];
    order.billing_detail_street = _formData['billingStreet'];
    order.billing_detail_city = _formData['billingCity'];
    order.billing_detail_state = _formData['billingState'];
    order.billing_detail_postcode = _formData['billingPostcode'];
    order.billing_detail_country = _formData['billingCountry'];
    order.billing_detail_phone = _formData['billingPhone'];
    order.billing_detail_email = _formData['billingEmail'];
    order.shipping_detail_first_name = _formData['shippingFirstName'];
    order.shipping_detail_last_name = _formData['shippingLastName'];
    order.shipping_detail_street = _formData['shippingStreet'];
    order.shipping_detail_city = _formData['shippingCity'];
    order.shipping_detail_state = _formData['shippingState'];
    order.shipping_detail_postcode = _formData['shippingPostcode'];
    order.shipping_detail_country = _formData['shippingCountry'];
    order.shipping_detail_phone = _formData['shippingPhone'];
    order.additional_instructions = _formData['additionalInstructions'];
    order.discount_code = ''; // @todo: _formData['discountCode'];

    var orderTotal = 0.0;
    stateStore.cart.forEach((cartItem) {
      orderTotal += double.parse(cartItem.total_price);
    });
    order.item_total = orderTotal.toString();
    order.total = orderTotal.toString();

    // Save the cart and cart items...
    stateStore.cartsCreate(cart).then((value) {
      var cartId = value.id;

      // After creating the cart, save all cart items
      stateStore.cart.forEach((cartItem) {
        cartItem.cart = cartId;
        cartItem.url = 'TBC';
        // @note: Should really wait for these calls to complete, but since all data of the 
        // items already exist here on the client (the phone), 
        // and should not affect any of the custom handlers on the server, 
        // these server calls can complete whenever, and execution can continue.
        stateStore.cartItemsCreate(cartItem);
      });

      // Save the order and order items...
      stateStore.ordersCreate(order).then((value) {
        var orderId = value.id;

        OrderForm data = new OrderForm();
        data.billing_detail_first_name = order.billing_detail_first_name;
        data.billing_detail_last_name = order.billing_detail_last_name;
        data.billing_detail_street = order.billing_detail_street;
        data.billing_detail_city = order.billing_detail_city;
        data.billing_detail_state = order.billing_detail_state;
        data.billing_detail_postcode = order.billing_detail_postcode;
        data.billing_detail_country = order.billing_detail_country;
        data.billing_detail_phone = order.billing_detail_phone;
        data.billing_detail_email = order.billing_detail_email;
        
        data.shipping_detail_first_name = order.shipping_detail_first_name;
        data.shipping_detail_last_name = order.shipping_detail_last_name;
        data.shipping_detail_street = order.shipping_detail_street;
        data.shipping_detail_city = order.shipping_detail_city;
        data.shipping_detail_state = order.shipping_detail_state;
        data.shipping_detail_postcode = order.shipping_detail_postcode;
        data.shipping_detail_country = order.shipping_detail_country;
        data.shipping_detail_phone = order.shipping_detail_phone;
        
        data.additional_instructions = order.additional_instructions;
        data.discount_code = order.discount_code;

        data.card_name = _formData['cardName'];
        data.card_type = _formData['cardType'];
        data.card_number = _formData['cardNumber'];
        data.card_expiry_month = _formData['cardExpiryMonth'];
        data.card_expiry_year = int.parse(_formData['cardExpiryYear']);
        data.card_ccv = _formData['cardCcv'];

        // After creating the order, save all order items
        stateStore.cart.forEach((cartItem) {
          OrderItem orderItem = new OrderItem();

          orderItem.order = orderId;
          orderItem.sku = cartItem.sku;
          orderItem.description = cartItem.description;
          orderItem.quantity = cartItem.quantity;
          orderItem.unit_price = cartItem.unit_price;
          orderItem.total_price = cartItem.total_price;

          // @note: Should really wait for these calls to complete, but since all data of the 
          // items already exist here on the client (the phone), 
          // and should not affect any of the custom handlers on the server, 
          // these server calls can complete whenever, and execution can continue.
          stateStore.orderItemsCreate(orderItem);
        });

        // Then calculate shipping and tax, and complete placing the order

        // For mobile, only calculate shipping, tax and do the payment and order placement in one go, 
        // so set the step number to the payment step, depending on the system settings.
        // @note: If any customisation work is done in the Mezzanine site installation for the 
        // handlers for billing/shipping, tax, payment and order placement that involves other steps,
        // update this.
        data.step = OneStepOrder['Checkout'];
        if (checkoutStepConfirmation) {
          data.step = OneStepWithConfirmationOrder['Confirmation'];
        }
        if (shopCheckoutStepsSplit) {
          data.step = TwoStepsOrder['Payment'];
          if (checkoutStepConfirmation) {
            data.step = TwoStepsWithConfirmationOrder['Payment'];
          }
        }

        // Calculate shipping...
        CartBillingShipping shippingData = new CartBillingShipping();
        shippingData.form = data;
        stateStore.cartsBillingShipping(cartId, shippingData).then((value) {
          var returnedSession = jsonDecode(value.returned_session);
          order.shipping_type = returnedSession['shipping_type'];
          order.shipping_total = returnedSession['shipping_total'];
          orderTotal += double.parse(order.shipping_total);
          order.total = orderTotal.toString();
          print('order total: ' + order.total);

          // Calculate tax...
          CartTax taxData = new CartTax();
          taxData.form = data;
          taxData.order_id = orderId;
          stateStore.cartsTax(cartId, taxData).then((value) {
            var returnedSession = jsonDecode(value.returned_session);
            order.tax_type = returnedSession['tax_type'];
            order.tax_total = returnedSession['tax_total'];
            orderTotal += double.parse(order.tax_total);
            order.total = orderTotal.toString();

            // Process payment...
            CartPayment paymentData = new CartPayment();
            paymentData.form = data;
            paymentData.order_id = orderId;
            stateStore.cartsPayment(cartId, paymentData).then((value) {

              // Update the order...
              order.status = OrderStatus['Processed'];
              stateStore.ordersUpdate(orderId, order).then((value) {

                // Complete placing the order...
                OrderPlacement orderPlacementData = new OrderPlacement();
                orderPlacementData.form = data;
                orderPlacementData.order_id = orderId;
                stateStore.ordersPlacement(cartId, orderPlacementData).then((value) {
                  this.setState(() {
                    _formData['submitted'] = false;
                  });

                  // And the order is complete... 
                  // @note: This would be more readable with await...
                  // https://www.dartlang.org/articles/language/await-async#await-expressions
                  _orderCompleteDialog(context);

                }).catchError((e) { // Order placement error handling
                  this.setState(() {
                    _formData['submitted'] = false;
                  });
                });
              }).catchError((e) { // Order update error handling
                this.setState(() {
                  _formData['submitted'] = false;
                });
              });
            }).catchError((e) { // Payment processing error handling
              this.setState(() {
                _formData['submitted'] = false;
              });
              if (e is ApiException && (e as ApiException).code == 500) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Unsuccessful payment. Please try again')));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something unexpected happened! Please try again')));
              }
            });
          }).catchError((e) { // Tax calculation error handling
            this.setState(() {
              _formData['submitted'] = false;
            });
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something unexpected happened! Please try again')));
          });
        }).catchError((e) { // Shipping calculation error handling
          this.setState(() {
            _formData['submitted'] = false;
          });
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something unexpected happened! Please try again')));
        });
      }).catchError((e) { // Order creation error handling
        this.setState(() {
          _formData['submitted'] = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something unexpected happened! Please try again')));
      });
    }).catchError((e) { // Cart creation error handling
      this.setState(() {
        _formData['submitted'] = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something unexpected happened! Please try again')));
    });
  }

  void _formSubmit(BuildContext context) {
    _billingCountryKey.currentState.resetValidation();
    if (_shippingCountryKey.currentState != null) {
      _shippingCountryKey.currentState.resetValidation();
    }
    _cardExpiryYearKey.currentState.resetValidation();
    _cardExpiryMonthKey.currentState.resetValidation();

    var billingIsValid = _formKeyBilling.currentState.validate();
    var shippingIsValid = _formKeyShipping.currentState.validate();
    var paymentIsValid = _formKeyPayment.currentState.validate();
    if (!billingIsValid) {
      setState(() {
        _formData['step'] = 0;
      });
    } else if (!shippingIsValid) {
      setState(() {
        _formData['step'] = 1;
      });
    } else if (!paymentIsValid) {
      setState(() {
        _formData['step'] = 2;
      });
    } else {
      _formKeyBilling.currentState.save();
      _formKeyShipping.currentState.save();
      _formKeyPayment.currentState.save();
      _formData['saved'] = true;

      this.setState(() {
        _formData['submitted'] = true;
      });

      _createOrder(context);
    }
  }

  @override
  initState() {
    super.initState();
    
    _formData['step'] = 0;
    _formData['submitted'] = false;

    _billingFirstNameController = new TextEditingController();
    _billingFirstNameFocus = new FocusNode();
    _billingLastNameController = new TextEditingController();
    _billingLastNameFocus = new FocusNode();
    _billingStreetController = new TextEditingController();
    _billingStreetFocus = new FocusNode();
    _billingCityController = new TextEditingController();
    _billingCityFocus = new FocusNode();
    _billingStateController = new TextEditingController();
    _billingStateFocus = new FocusNode();
    _billingPostcodeController = new TextEditingController();
    _billingPostcodeFocus = new FocusNode();
    _billingCountryKey = new GlobalKey<DropdownWidgetState>();
    _billingPhoneController = new TextEditingController();
    _billingPhoneFocus = new FocusNode();
    _billingEmailController = new TextEditingController();
    _billingEmailFocus = new FocusNode();

    _shippingFirstNameController = new TextEditingController();
    _shippingFirstNameFocus = new FocusNode();
    _shippingLastNameController = new TextEditingController();
    _shippingLastNameFocus = new FocusNode();
    _shippingStreetController = new TextEditingController();
    _shippingStreetFocus = new FocusNode();
    _shippingCityController = new TextEditingController();
    _shippingCityFocus = new FocusNode();
    _shippingStateController = new TextEditingController();
    _shippingStateFocus = new FocusNode();
    _shippingPostcodeController = new TextEditingController();
    _shippingPostcodeFocus = new FocusNode();
    _shippingCountryKey = new GlobalKey<DropdownWidgetState>();
    _shippingPhoneController = new TextEditingController();
    _shippingPhoneFocus = new FocusNode();

    _additionalInstructionsController = new TextEditingController();
    _additionalInstructionsFocus = new FocusNode();

    _discountCodeController = new TextEditingController();
    _discountCodeFocus = new FocusNode();

    _cardNameController = new TextEditingController();
    _cardNameFocus = new FocusNode();
    _cardNumberController = new TextEditingController();
    _cardNumberFocus = new FocusNode();
    _cardExpiryMonthKey = new GlobalKey<DropdownWidgetState>();
    _cardExpiryYearKey = new GlobalKey<DropdownWidgetState>();
    _cardCcvController = new TextEditingController();
    _cardCcvFocus = new FocusNode();

    for (var i = DateTime.now().year; i < DateTime.now().year + 10; i++) {
      _cardYears[i.toString()] = i.toString();
    }
  }

  @override
  void dispose() {
    _billingFirstNameController.dispose();
    _billingFirstNameFocus.dispose();
    _billingLastNameController.dispose();
    _billingLastNameFocus.dispose();
    _billingStreetController.dispose();
    _billingStreetFocus.dispose();
    _billingCityController.dispose();
    _billingCityFocus.dispose();
    _billingStateController.dispose();
    _billingStateFocus.dispose();
    _billingPostcodeController.dispose();
    _billingPostcodeFocus.dispose();
    _billingPhoneController.dispose();
    _billingPhoneFocus.dispose();
    _billingEmailController.dispose();
    _billingEmailFocus.dispose();

    _shippingFirstNameController.dispose();
    _shippingFirstNameFocus.dispose();
    _shippingLastNameController.dispose();
    _shippingLastNameFocus.dispose();
    _shippingStreetController.dispose();
    _shippingStreetFocus.dispose();
    _shippingCityController.dispose();
    _shippingCityFocus.dispose();
    _shippingStateController.dispose();
    _shippingStateFocus.dispose();
    _shippingPostcodeController.dispose();
    _shippingPostcodeFocus.dispose();
    _shippingPhoneController.dispose();
    _shippingPhoneFocus.dispose();
    
    _additionalInstructionsController.dispose();
    _additionalInstructionsFocus.dispose();

    _discountCodeController.dispose();
    _discountCodeFocus.dispose();

    _cardNameController.dispose();
    _cardNameFocus.dispose();
    _cardNumberController.dispose();
    _cardNumberFocus.dispose();
    _cardCcvController.dispose();
    _cardCcvFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.fetchSettingsFuture.status == FutureStatus.pending) {
        return Container();
      }

      // Populate the user fields with current user data, if the form has not already been saved, 
      // i.e. do not overwrite changes after the user has tapped next/back
      if (_formData['saved'] = false && stateStore.currentUser != null) {
        _billingFirstNameController.text = stateStore.currentUser.first_name == null ? '' : stateStore.currentUser.first_name;
        _billingLastNameController.text = stateStore.currentUser.last_name == null ? '' : stateStore.currentUser.last_name;
        _billingEmailController.text = stateStore.currentUser.email == null ? '' : stateStore.currentUser.email;
        _shippingFirstNameController.text = stateStore.currentUser.first_name == null ? '' : stateStore.currentUser.first_name;
        _shippingLastNameController.text = stateStore.currentUser.last_name == null ? '' : stateStore.currentUser.last_name;
      }

      // @note: Always split the address and payment steps for mobile
      // final SystemSetting settingShopCheckoutStepsSplit = stateStore.systemSettingList.firstWhere((setting) => setting.name == 'SHOP_CHECKOUT_STEPS_SPLIT', orElse: () => null);
      // var shopCheckoutStepsSplit = false;
      // if (settingShopCheckoutStepsSplit != null) {
      //   shopCheckoutStepsSplit = settingShopCheckoutStepsSplit.value.toLowerCase() == 'true';
      // }
      final SystemSetting settingShopPaymentStepEnabled = stateStore.systemSettingList.firstWhere((setting) => setting.name == 'SHOP_PAYMENT_STEP_ENABLED', orElse: () => null);
      var shopPaymentStepEnabled = false;
      if (settingShopPaymentStepEnabled != null) {
        shopPaymentStepEnabled = settingShopPaymentStepEnabled.value.toLowerCase() == 'true';
      }
      // @note: Confirmation step not applicable to mobile: The user can easily review the form using the stepper
      // final SystemSetting settingCheckoutStepConfirmation = stateStore.systemSettingList.firstWhere((setting) => setting.name == 'SHOP_CHECKOUT_STEPS_CONFIRMATION', orElse: () => null);
      // var checkoutStepConfirmation = false;
      // if (settingCheckoutStepConfirmation != null) {
      //   checkoutStepConfirmation = settingCheckoutStepConfirmation.value.toLowerCase() == 'true';
      // }

      final SystemSetting settingShopHandlerPayment = stateStore.systemSettingList.firstWhere((setting) => setting.name == 'SHOP_HANDLER_PAYMENT', orElse: () => null);
      var shopHandlerPayment = null;
      if (settingShopHandlerPayment != null) {
        shopPaymentStepEnabled = true;
        shopHandlerPayment = settingShopHandlerPayment.value;
      }

      List<Widget> billingFields = [
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _billingFirstNameController,
          focusNode: _billingFirstNameFocus,
          onSaved: (value) {
            _formData['billingFirstName'] = value;
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
          controller: _billingLastNameController,
          focusNode: _billingLastNameFocus,
          onSaved: (value) {
            _formData['billingLastName'] = value;
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
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _billingStreetController,
          focusNode: _billingStreetFocus,
          onSaved: (value) {
            _formData['billingStreet'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Street',
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
          controller: _billingCityController,
          focusNode: _billingCityFocus,
          onSaved: (value) {
            _formData['billingCity'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'City',
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
          controller: _billingStateController,
          focusNode: _billingStateFocus,
          onSaved: (value) {
            _formData['billingState'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'State',
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
          controller: _billingPostcodeController,
          focusNode: _billingPostcodeFocus,
          onSaved: (value) {
            _formData['billingPostcode'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Postcode',
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
        DropdownWidget(
          key: _billingCountryKey,
          hint: 'Country',
          value: _formData['billingCountry'],
          items: countryData,
          required: true,
          onChanged: (String value) {
            setState(() {
              _formData['billingCountry'] = value;
            });
          },
        ),
        SizedBox (
          height: appGeneralSpacing
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          controller: _billingPhoneController,
          focusNode: _billingPhoneFocus,
          onSaved: (value) {
            _formData['billingPhone'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Phone',
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
          controller: _billingEmailController,
          focusNode: _billingEmailFocus,
          onSaved: (value) {
            _formData['billingEmail'] = value;
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
      ];

      List<Widget> shippingFields = [
        CheckboxListTile(
          title: const Text('My delivery details are the same as my billing details'),
          activeColor: checkboxColour,
          onChanged: (value) {
            setState(() {
              _formData['sameBillingShipping'] = value;
            });
            _checkAndSetSameBillingShipping();
          },
          value: _formData['sameBillingShipping'],
        ),
        SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _shippingFirstNameController,
          focusNode: _shippingFirstNameFocus,
          onSaved: (value) {
            _formData['shippingFirstName'] = value;
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
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _shippingLastNameController,
          focusNode: _shippingLastNameFocus,
          onSaved: (value) {
            _formData['shippingLastName'] = value;
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
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _shippingStreetController,
          focusNode: _shippingStreetFocus,
          onSaved: (value) {
            _formData['shippingStreet'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Street',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Required';
            }
          },
        ),
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _shippingCityController,
          focusNode: _shippingCityFocus,
          onSaved: (value) {
            _formData['shippingCity'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'City',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Required';
            }
          },
        ),
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _shippingStateController,
          focusNode: _shippingStateFocus,
          onSaved: (value) {
            _formData['shippingState'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'State',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Required';
            }
          },
        ),
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _shippingPostcodeController,
          focusNode: _shippingPostcodeFocus,
          onSaved: (value) {
            _formData['shippingPostcode'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Postcode',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Required';
            }
          },
        ),
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : DropdownWidget(
          key: _shippingCountryKey,
          hint: 'Country',
          value: _formData['shippingCountry'],
          items: countryData,
          required: true,
          onChanged: (String value) {
            setState(() {
              _formData['shippingCountry'] = value;
            });
          },
        ),
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        _formData['sameBillingShipping'] ? Container() : TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          controller: _shippingPhoneController,
          focusNode: _shippingPhoneFocus,
          onSaved: (value) {
            _formData['shippingPhone'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Phone',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Required';
            }
          },
        ),
        _formData['sameBillingShipping'] ? Container() : SizedBox (
          height: appGeneralSpacing
        ),
        TextFormField(
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          controller: _additionalInstructionsController,
          focusNode: _additionalInstructionsFocus,
          onSaved: (value) {
            _formData['additionalInstructions'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Additional instructions',
          ),
        ),
        SizedBox (
          height: appGeneralSpacing
        ),
      ];

      List<Widget> paymentFields = [
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _cardNameController,
          focusNode: _cardNameFocus,
          onSaved: (value) {
            _formData['cardName'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Cardholder name',
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
        Column(
          children: <Widget>[
            RadioListTile<String>(
              activeColor: radiobuttonColour,
              title: const Text('Mastercard'),
              value: 'Mastercard',
              groupValue: _formData['cardType'],
              onChanged: (String value) { setState(() { _formData['cardType'] = value; }); },
            ),
            RadioListTile<String>(
              activeColor: radiobuttonColour,
              title: const Text('Visa'),
              value: 'Visa',
              groupValue: _formData['cardType'],
              onChanged: (String value) { setState(() { _formData['cardType'] = value; }); },
            ),
            RadioListTile<String>(
              activeColor: radiobuttonColour,
              title: const Text('Diners'),
              value: 'Diners',
              groupValue: _formData['cardType'],
              onChanged: (String value) { setState(() { _formData['cardType'] = value; }); },
            ),
            RadioListTile<String>(
              activeColor: radiobuttonColour,
              title: const Text('Amex'),
              value: 'Amex',
              groupValue: _formData['cardType'],
              onChanged: (String value) { setState(() { _formData['cardType'] = value; }); },
            ),
          ],
        ),
        SizedBox (
          height: appGeneralSpacing
        ),

        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _cardNumberController,
          focusNode: _cardNumberFocus,
          onSaved: (value) {
            _formData['cardNumber'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Card number',
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
        Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3, 
              child: DropdownWidget(
                key: _cardExpiryMonthKey,
                hint: 'Month', // 'Card expiry month',
                value: _formData['cardExpiryMonth'],
                items: monthData,
                required: true,
                onChanged: (String value) {
                  setState(() {
                    _formData['cardExpiryMonth'] = value;
                  });
                },
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4, 
              child: DropdownWidget(
                key: _cardExpiryYearKey,
                hint: 'Year', // 'Card expiry year',
                value: _formData['cardExpiryYear'],
                items: _cardYears,
                required: true,
                onChanged: (String value) {
                  setState(() {
                    _formData['cardExpiryYear'] = value;
                  });
                },
              )
            ),
          ]
        ),
        SizedBox (
          height: appGeneralSpacing
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: _cardCcvController,
          focusNode: _cardCcvFocus,
          onSaved: (value) {
            _formData['cardCcv'] = value;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Card CCV',
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
      ];

      // @todo: This app will only work with Mezzanine Cartridge site installations with payment enabled.
      // The stepper widget could be updated to allow steps to change dynamically: https://github.com/flutter/flutter/pull/31379
      // var _steps = [
      //   Step(
      //     title: Text('Billing Details'),
      //     content: Form(
      //       key: _formKeyBilling,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: billingFields,
      //       ),
      //     ),
      //   ),
      //   Step(
      //     title: Text('Delivery Details'),
      //     content: Form(
      //       key: _formKeyShipping,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: shippingFields,
      //       ),
      //     ),
      //   ),
      // ];

      // if (shopPaymentStepEnabled) {
      //   _steps.add (
      //     Step(
      //       title: Text('Payment'),
      //       content: Form(
      //         key: _formKeyPayment,
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: paymentFields,
      //         ),
      //       )
      //     )
      //   );
      // }

      // @note: Adjust the number of steps here as needed
      var _steps = [
        Step(
          title: Text('Billing Details'),
          content: Form(
            key: _formKeyBilling,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: billingFields,
            ),
          ),
        ),
        Step(
          title: Text('Delivery Details'),
          content: Form(
            key: _formKeyShipping,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: shippingFields,
            ),
          ),
        ),
        Step(
          title: Text('Payment'),
          content: Form(
            key: _formKeyPayment,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: paymentFields,
            ),
          )
        )
      ];

      return Container(
        margin: Device.get().isIphoneX && MediaQuery.of(context).orientation == Orientation.landscape
          ? const EdgeInsets.only(left: appLeftMarginStepper_iPhoneX, right: appRightMargin, bottom: appBottomMargin)
          : const EdgeInsets.only(left: appLeftMarginStepper, right: appRightMargin, bottom: appBottomMargin),
        child: Stepper(
          currentStep: _formData['step'],
          type: StepperType.vertical,
          steps: _steps,

          onStepTapped: (index) {
            _stepChangeSave();
            setState(() {
              _formData['step'] = index;
            });
          },
          onStepCancel: () {
            _stepChangeSave();
            if (_formData['step'] > 0) {
              setState(() {
                _formData['step'] = _formData['step'] - 1;
              });
            }
          },
          onStepContinue: () {
            _stepChangeSave();
            if (_formData['step'] < _steps.length) {
              setState(() {
                _formData['step'] = _formData['step'] + 1;
              });
            }
          },

          controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(
              children: <Widget>[
                _formData['submitted']
                ? AppProgressIndicator()
                : RaisedButton(
                  onPressed: () {
                    if (_formData['step'] < _steps.length - 1) {
                      onStepContinue();
                    } else {
                      _formSubmit(context);
                    }
                  },
                  child: const Text('Next'),
                ),
                _formData['submitted'] ? Container()
                : SizedBox (
                  width: appGeneralSpacing
                ),
                _formData['submitted'] ? Container()
                : _formData['step'] > 0 
                ? RaisedButton(
                  onPressed: onStepCancel,
                  child: const Text('Back'),
                )
                : Container(),
              ],
            );
          },
        )
      );
    }
  );
}
