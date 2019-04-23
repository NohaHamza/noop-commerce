part of '../../main.dart';

class FavouriteContent extends StatefulWidget {
  FavouriteContent(this.showMessage);
  final void Function(SnackBar) showMessage;

  @override
  State<StatefulWidget> createState() => FavouriteContentState(showMessage);
}

class FavouriteContentState extends State<FavouriteContent> {
  FavouriteContentState(this.showMessage);
  final void Function(SnackBar) showMessage;

  FavouriteView favouriteView;

  @override
  initState() {
    favouriteView = new FavouriteView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return stateStore.currentFavouriteContentRoute == FavouriteContentRoute.favourite ? favouriteView
    : Container();
  }
}
