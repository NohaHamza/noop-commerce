part of '../../main.dart';

class HomeContent extends StatefulWidget {
  HomeContent(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  State<StatefulWidget> createState() => HomeContentState(showMessage);
}

class HomeContentState extends State<HomeContent> {
  HomeContentState(this.showMessage);
  final void Function(SnackBar) showMessage;

  ShopView shopView;
  CategoryView categoryView;
  ProductView productView;
  ProductPhotoView productPhotoView;

  @override
  initState() {
    shopView = new ShopView();
    categoryView = new CategoryView();
    productView = new ProductView(showMessage);
    productPhotoView = new ProductPhotoView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return stateStore.currentHomeContentRoute == HomeContentRoute.shop ? shopView
    : stateStore.currentHomeContentRoute == HomeContentRoute.category ? categoryView
    : stateStore.currentHomeContentRoute == HomeContentRoute.product ? productView
    : stateStore.currentHomeContentRoute == HomeContentRoute.productPhoto ? productPhotoView 
    : Container();
  }
}
