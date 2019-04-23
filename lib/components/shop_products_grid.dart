part of '../main.dart';

class ShopProductsGrid extends StatelessWidget {
  ShopProductsGrid({ this.showFavouriteProducts = false });
  final bool showFavouriteProducts;

  @override
  Widget build(BuildContext context) => Container (
    child: Observer (
      builder: (_) {
        if (!stateStore.hasProductsResults 
          || !stateStore.hasSystemSettingsResults) {
          return Container();
        }

        List<Widget> productWidgetList = [];
        List<Widget> productRowWidgetList = [];
        var productsPerRow = MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2;
        var productRowCellWidth // Setting this to double.infinity here breaks the view, so calculate the width
          = Device.get().isIphoneX && MediaQuery.of(context).orientation == Orientation.landscape
          ? (MediaQuery.of(context).size.width - (appLeftMargin_iPhoneX + appRightMargin) - ((productsPerRow - 1) * appGeneralSpacing * 2)) / productsPerRow
          : (MediaQuery.of(context).size.width - (appLeftMargin + appRightMargin) - ((productsPerRow - 1) * appGeneralSpacing * 2)) / productsPerRow;

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

        var currentProductCount = 0;
        var addedProductCount = 0;
        stateStore.productList.sort((a, b) => a.title.compareTo(b.title));
        stateStore.productList.forEach((product) {
          currentProductCount++;

          final productPrice = shopCurrencySymbol + ' ' + shopCurrencyFormat.format(double.parse(product.variations[0].unit_price));

          var productWidget = Column(
            children: [
              InkWell(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: productRowCellWidth,
                    maxWidth: productRowCellWidth
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: Theme.of(context).textTheme.title),
                      SizedBox(height: appGeneralSpacing),

                      product.images.length > 0 
                      ? FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: (siteMediaUrl + product.images[0].file),
                      ) 
                      : Container(),
                      SizedBox(height: appGeneralSpacing),

                      product.variations.length > 0
                      ? Text(productPrice, style: Theme.of(context).textTheme.subtitle)
                      : Text('Unavailable', style: Theme.of(context).textTheme.subtitle),

                      Html(data: product.content),
                    ]
                  )
                ),
                onTap: () {
                  stateStore.setCurrentProduct(product);
                  stateStore.setHomeContentRoute(HomeContentRoute.product);
                }
              ),
              Container(
                height: appGeneralSpacing * 2
              )
            ]
          );

          // If showing favourite products, add favourite products
          if (showFavouriteProducts) {
            if (stateStore.favouriteList.contains(product)) {
              addedProductCount++;
              productRowWidgetList.add(productWidget);
            }
          }
          // If not the category view, add all products
          // If the category view, only add products in the current category
          else if (stateStore.currentCategory == null
            || product.categories.indexWhere((category) => category.id == stateStore.currentCategory.id) != -1) {
            addedProductCount++;
            productRowWidgetList.add(productWidget);
          }

          // Add the set number of widgets to the row widget, 
          // or add the remainder of widgets if this is the last row
          if (productRowWidgetList.length == productsPerRow
            || currentProductCount == stateStore.productList.length) {

            productWidgetList.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: productRowWidgetList
              )
            );
            productRowWidgetList = [];
          }
        });

        if (showFavouriteProducts && stateStore.favouriteList.length == 0) {
          return Text('You have not added any favourite products yet.');
        }

        if (addedProductCount == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('No products available at this time.'),
            ],
          );
        }

        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: productWidgetList
          )
        );

      },
    ),
  );
}
