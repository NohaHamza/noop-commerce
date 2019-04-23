part of '../main.dart';

class ProductsLoadingError extends StatelessWidget {
  ProductsLoadingError();

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) => 
      stateStore.fetchCategoriesFuture.status == FutureStatus.rejected
      || stateStore.fetchProductsFuture.status == FutureStatus.rejected
      || stateStore.fetchSystemSettingsFuture.status == FutureStatus.rejected
      ? new Container(
          margin: Device.get().isIphoneX && MediaQuery.of(context).orientation == Orientation.landscape
            ? const EdgeInsets.only(top: appTopMargin, left: appLeftMargin_iPhoneX, right: appRightMargin, bottom: appBottomMargin)
            : const EdgeInsets.only(top: appTopMargin, left: appLeftMargin, right: appRightMargin, bottom: appBottomMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Failed to connect', style: Theme.of(context).textTheme.title),
              RaisedButton(
                child: const Text('Retry'),
                onPressed: () => initAppState(),
              ),
            ]
          )
        )
      : Container()
  );
}

