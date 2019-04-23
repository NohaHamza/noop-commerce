part of '../../main.dart';

class ProductView extends StatelessWidget {
  ProductView(this.showMessage);
  final void Function(SnackBar) showMessage;

  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
      SystemSetting siteUrlSetting = stateStore.systemSettingList.firstWhere((systemSetting) => systemSetting.name == 'SITE_DOMAIN', orElse: () => null);
      if (siteUrlSetting != null) {
        siteUrl = siteUrlSetting.value.replaceFirst(new RegExp(r'/$'), '');
      }

      String siteMediaUrl = siteUrl + '/media';
      SystemSetting mediaUrlSetting = stateStore.systemSettingList.firstWhere((systemSetting) => systemSetting.name == 'MEDIA_URL', orElse: () => null);
      if (mediaUrlSetting != null) {
        if (mediaUrlSetting.value.startsWith('http')) {
          siteMediaUrl = mediaUrlSetting.value;
        } else {
          siteMediaUrl = siteUrl + mediaUrlSetting.value;
        }
      }

    final product = stateStore.currentProduct;

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          var productImageContainerHeight = 300.0;
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            productImageContainerHeight = MediaQuery.of(context).size.height;
          }

          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: productImageContainerHeight,
                        flexibleSpace: FlexibleSpaceBar(
                          background: GestureDetector(
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[

                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: appLinearGradient,
                                  ),
                                ),
                                product.images.length > 0 
                                ? FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: (siteMediaUrl + product.images[0].file),
                                  fit: BoxFit.cover,
                                  height: productImageContainerHeight,
                                ) 
                                : Container(),

                              ],
                            ),
                            onTap: () {
                              if (MediaQuery.of(context).orientation == Orientation.landscape) {
                                _scrollController.animateTo(
                                  productImageContainerHeight,
                                  curve: Curves.linear, 
                                  duration: Duration (milliseconds: appGeneralAnimationDuration),
                                );
                              } else if (product.images.length > 0) {
                                var productImage = Tuple2<Product, ProductImage>(product, product.images[0]);
                                stateStore.setHomeContentRoute(HomeContentRoute.productPhoto);
                              }
                            },
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: double.infinity),
                                child: Container (
                                  margin: Device.get().isIphoneX && MediaQuery.of(context).orientation == Orientation.landscape
                                    ? const EdgeInsets.only(top: appTopMargin, left: appLeftMargin_iPhoneX, right: appRightMargin, bottom: appBottomMargin)
                                    : const EdgeInsets.only(top: appTopMargin, left: appLeftMargin, right: appRightMargin, bottom: appBottomMargin),
                                  child: ProductDetailView(showMessage)

                                )
                              ),

                           ]
                          )
                        ]),
                      ),
                    ]
                  )
                ),
              ],
            )
          );
        }
      )
    );
  }
}

class ProductDetailView extends StatelessWidget {
  ProductDetailView(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  Widget build(BuildContext context) {
    if (!stateStore.hasProductsResults 
      || !stateStore.hasSystemSettingsResults) {
      return Container();
    }

    if (stateStore.productList.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('No products available at this time'),
        ],
      );
    }

    String siteMediaUrl = siteUrl + '/media';
    SystemSetting mediaUrlSetting = stateStore.systemSettingList.firstWhere((systemSetting) => systemSetting.name == 'MEDIA_URL', orElse: () => null);
    if (mediaUrlSetting != null) {
      if (mediaUrlSetting.value.startsWith('http')) {
        siteMediaUrl = mediaUrlSetting.value;
      } else {
        siteMediaUrl = siteUrl + mediaUrlSetting.value;
      }
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

    final product = stateStore.currentProduct;
    final productPrice = shopCurrencySymbol + ' ' + shopCurrencyFormat.format(double.parse(product.variations[0].unit_price));

    var columnsPerRow = 1;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      columnsPerRow = 3;
    }
    var rowCellWidth
      = MediaQuery.of(context).orientation == Orientation.landscape && Device.get().isIphoneX
      ? (MediaQuery.of(context).size.width - (appLeftMargin_iPhoneX + appRightMargin) - ((columnsPerRow - 1) * appGeneralSpacing * 2)) / columnsPerRow
      : MediaQuery.of(context).orientation == Orientation.landscape && Device.get().isIphoneX
      ? (MediaQuery.of(context).size.width - (appLeftMargin + appRightMargin) - ((columnsPerRow - 1) * appGeneralSpacing * 2)) / columnsPerRow
      : (MediaQuery.of(context).size.width - (appLeftMargin + appRightMargin) - ((columnsPerRow - 1) * appGeneralSpacing * 2)) / columnsPerRow;
    
    var productDetailConstraints = BoxConstraints(minWidth: rowCellWidth, maxWidth: rowCellWidth);
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      productDetailConstraints = BoxConstraints(minWidth: rowCellWidth * 2, maxWidth: rowCellWidth * 2);
    }
    var productFormConstraints = BoxConstraints(minWidth: rowCellWidth, maxWidth: rowCellWidth);

    var productAvailable = false;
    if (product.available && product.variations.length > 0) {
      product.variations.forEach((productVariation) {
        if (double.tryParse(productVariation.unit_price) != null) {
          productAvailable = true;
        }
      });
    }
    var productFormDisplay = productAvailable ? ProductForm(showMessage) : Text('This product is currently unavailable.');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: productDetailConstraints,
          child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: Theme.of(context).textTheme.headline),
                SizedBox(height: appGeneralSpacing),
                product.variations.length > 0
                ? Text(productPrice, style: Theme.of(context).textTheme.subtitle)
                : Text('Unavailable', style: Theme.of(context).textTheme.subtitle),
                Html(
                  data: product.content
                ),
                SizedBox(height: appGeneralSpacing * 3),
                (MediaQuery.of(context).orientation == Orientation.landscape)
                ? Container()
                : productFormDisplay,
              ]
            ),
          ),
        (MediaQuery.of(context).orientation == Orientation.landscape)
        ? ConstrainedBox(
          constraints: productFormConstraints,
          child: productFormDisplay,
        )
        : Container(),
      ]
    );
  }
}

class ProductForm extends StatefulWidget {
  ProductForm(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  ProductFormState createState() {
    return ProductFormState(showMessage);
  }
}

class ProductFormState extends State<ProductForm> {
  ProductFormState(this.showMessage);
  final void Function(SnackBar) showMessage;

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'submitted': false,
    'quantity': null,
    'favourite': false
  };

  TextEditingController _quantityController;
  FocusNode _quantityFocus;

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _formData['submitted'] = true;

      // @note: Update this for using more than one product variation.
      // Mezzanine has a default variation for every product.
      // If you do custom work with variations, customise this starter app.
      var product = stateStore.currentProduct;
      // var productVariation = product.variations.firstWhere((productVariation) => productVariation.default_ == true, orElse: () => null);
      var productVariation = product.variations[0];

      if (stateStore.cart.firstWhere((cartItem) => cartItem.sku == productVariation.sku, orElse: () => null) == null) {
        var cartItem = new CartItem();
        cartItem.sku = productVariation.sku;
        cartItem.description = product.title;
        var qty = int.parse(_formData['quantity']);
        cartItem.quantity = qty;
        var price = double.tryParse(productVariation.unit_price) == null ? 0.0 : double.parse(productVariation.unit_price);
        cartItem.unit_price = price.toString();
        cartItem.total_price = (qty * price).toString();
        stateStore.addCartItem(cartItem);

        _formData['submitted'] = false;
        showMessage(SnackBar(content: Text('Added to your cart')));
      } else {
        var cartItem = stateStore.cart.firstWhere((cartItem) => cartItem.sku == productVariation.sku, orElse: () => null);
        var qty = int.parse(_formData['quantity']);
        cartItem.quantity += qty;
        stateStore.updateCartItem(cartItem);

        _formData['submitted'] = false;
        showMessage(SnackBar(content: Text('Quantity in cart updated')));
      }
    }
  }

  void _productLike() {
    if (!stateStore.favouriteList.contains(stateStore.currentProduct)) {
      this.setState(() {
        _formData['favourite'] = true;
      });
      stateStore.addFavourite(stateStore.currentProduct);
      showMessage(SnackBar(content: Text('Added as a favourite')));
    } else {
      this.setState(() {
        _formData['favourite'] = false;
      });
      stateStore.removeFavourite(stateStore.currentProduct);
      showMessage(SnackBar(content: Text('Removed favourite')));
    }
  }

  @override
  initState() {
    super.initState();
    _quantityController = new TextEditingController(text: '1');
    _quantityFocus = new FocusNode();
    _formData['favourite'] = stateStore.favouriteList.contains(stateStore.currentProduct);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              controller: _quantityController,
              focusNode: _quantityFocus,
              onSaved: (value) {
                _formData['quantity'] = value;
              },
              decoration: InputDecoration(
                filled: true,
                hintText: 'Quantity',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                } else if (double.tryParse(value) == null) {
                  return 'Must be a number';
                } else if (int.tryParse(value) == null) {
                  return 'Must be valid';
                }
              },
            ),
            SizedBox (
              height: appGeneralSpacing
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _formData['submitted'] == false 
                ? RaisedButton(
                  onPressed: () => _formSubmit(),
                  child: Text('Buy'),
                )
                : Container(),
                RaisedButton(
                  onPressed: () => _productLike(),
                  child: Icon(
                    Icons.favorite,
                    color: _formData['favourite'] ? Colors.red : Colors.black,
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}
