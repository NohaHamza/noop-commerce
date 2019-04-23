part of '../main.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation(this.showMessage);
  final void Function(SnackBar) showMessage;

  Color _isSelected({ContentItem item}) {
    return stateStore.currentContentItem == item ? activeMenuItemColour : menuItemColour;
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _isSelected(item: ContentItem.home)),
            title: Text('Shop', style: TextStyle(color: _isSelected(item: ContentItem.home)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _isSelected(item: ContentItem.favourite)),
            title: Text(
              'Favourite' + (stateStore.favouriteList.length > 0 ? ' (' + stateStore.favouriteList.length.toString() + ')' : ''), 
              style: TextStyle(color: _isSelected(item: ContentItem.favourite)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: _isSelected(item: ContentItem.checkout)),
            title: Text(
              'Cart' + (stateStore.cart.length > 0 ? ' (' + stateStore.cart.length.toString() + ')' : ''), 
              style: TextStyle(color: _isSelected(item: ContentItem.checkout)),
            ),
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              stateStore.setFavouriteContentRoute(FavouriteContentRoute.favourite);
              break;
            case 2:
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) => CartDrawer(),
              );
              break;
            default:
              stateStore.setHomeContentRoute(HomeContentRoute.shop);
              break;
          }
        },
      );
    }
  );
}
