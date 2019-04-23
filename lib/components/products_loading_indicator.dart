part of '../main.dart';

class ProductsLoadingIndicator extends StatelessWidget {
  const ProductsLoadingIndicator();

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) => stateStore.fetchCategoriesFuture.status == FutureStatus.pending 
      || stateStore.fetchProductsFuture.status == FutureStatus.pending 
      || stateStore.fetchSystemSettingsFuture.status == FutureStatus.pending
      ? AppProgressIndicator()
      : Container()
  );
}
