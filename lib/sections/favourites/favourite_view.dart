part of '../../main.dart';

class FavouriteView extends StatelessWidget {
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Observer (
                      builder: (_) {
                        return Text('My Favourite' + (stateStore.favouriteList.length == 0 ? '' : ' (' + stateStore.favouriteList.length.toString() + ')'), style: Theme.of(context).textTheme.display1);
                      }
                    ),
                    ProductsLoadingIndicator(),
                  ]
                )
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
                    child: ProductsLoadingError(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity),
                    child: Container (
                      margin: Device.get().isIphoneX && MediaQuery.of(context).orientation == Orientation.landscape
                        ? const EdgeInsets.only(top: appTopMargin, left: appLeftMargin_iPhoneX, right: appRightMargin, bottom: appBottomMargin)
                        : const EdgeInsets.only(top: appTopMargin, left: appLeftMargin, right: appRightMargin, bottom: appBottomMargin),
                      child: ShopProductsGrid(showFavouriteProducts: true)
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
