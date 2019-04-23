part of '../main.dart';

class MenuNavigation extends StatelessWidget {
  MenuNavigation(this.showMessage);
  final void Function(SnackBar) showMessage;

  Color _isSelected({ContentItem item}) {
    if (item == ContentItem.home) {
      if (stateStore.currentHomeContentRoute == HomeContentRoute.shop) {
        return activeMenuItemColour;
      } else {
        return menuItemColour;
      }
    }

    return stateStore.currentContentItem == item ? activeMenuItemColour : menuItemColour;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            // child: Text('Mezzanine Shop App', style: Theme.of(context).textTheme.display2),
            child: AppTitle(style: Theme.of(context).textTheme.display2),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text(
              'Shop',
              style: Theme.of(context).textTheme.title
                .merge(TextStyle(color: _isSelected(item: ContentItem.home)))
            ),
            onTap: () {
              stateStore.setHomeContentRoute(HomeContentRoute.shop);
              Navigator.of(context).pop();
            }
          ),
          CategoryMenu(),
          ListTile(
            title: Text(
              'Favourite' + (stateStore.favouriteList.length > 0 ? ' (' + stateStore.favouriteList.length.toString() + ')' : ''), 
              style: Theme.of(context).textTheme.title
                .merge(TextStyle(color: _isSelected(item: ContentItem.favourite)))
            ),
            onTap: () {
              stateStore.setFavouriteContentRoute(FavouriteContentRoute.favourite);
              Navigator.of(context).pop();
            }
          ),
          ListTile(
            title: Text(
              'Cart' + (stateStore.cart.length > 0 ? ' (' + stateStore.cart.length.toString() + ')' : ''), 
              style: Theme.of(context).textTheme.title
                .merge(TextStyle(color: menuItemColour))
            ),
            onTap: () {
              Navigator.of(context).pop();
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) => CartDrawer(),
              );
            }
          ),
          UserMenu(showMessage),
        ],
      ),
    );
  }
}

class CategoryMenu extends StatelessWidget {
  Color _isSelected(Category category) {
    return stateStore.currentCategory == category && stateStore.currentHomeContentRoute == HomeContentRoute.category ? activeMenuItemColour : menuItemColour;
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.fetchUsersFuture.status == FutureStatus.pending
      || !stateStore.hasCategoriesResults) {
        return Container(); // AppProgressIndicator();
      }

      List<Widget> categoryWidgetList = [];
      
      var currentCategoryCount = 0;
      stateStore.categoryList.sort((a, b) => a.title.compareTo(b.title));
      stateStore.categoryList.forEach((category) {
        currentCategoryCount++;

        var categoryWidget = ListTile(
          title: Text(category.title,
            style: Theme.of(context).textTheme.subtitle
              .merge(TextStyle(color: menuItemColour))
              .merge(TextStyle(color: _isSelected(category)))
          ),
          onTap: () {
            stateStore.setCurrentCategory(category);
            stateStore.setHomeContentRoute(HomeContentRoute.category);
            Navigator.of(context).pop();
          }
        );

        if (category.title != 'Shop') { // Don't include the "root" Shop category
          categoryWidgetList.add(categoryWidget);
        }
      });

      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryWidgetList
        )
      );

    }
  );
}

class UserMenu extends StatelessWidget {
  UserMenu(this.showMessage);
  final void Function(SnackBar) showMessage;

  Color _isSelected({ContentItem item, AccountContentRoute, route}) {
    return stateStore.currentContentItem == item && stateStore.currentAccountContentRoute == route ? activeMenuItemColour : menuItemColour;
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.fetchUsersFuture.status == FutureStatus.pending) {
        return Container(); // AppProgressIndicator();
      }

      if (stateStore.currentUser != null) {
        return Column(
          children: [
            ListTile(
              title: Text('Logged in as ' + stateStore.currentUserName,
                style: Theme.of(context).textTheme.title
                  .merge(TextStyle(color: activeMenuItemColour))
              ),
            ),
            ListTile(
              title: Text('Log out',
                style: Theme.of(context).textTheme.title
                  .merge(TextStyle(color: menuItemColour))
              ),
              onTap: () {
                stateStore.setCurrentUser(null);
                showMessage(SnackBar(content: Text('Successfully logged out')));
                stateStore.setHomeContentRoute(HomeContentRoute.shop);
                Navigator.of(context).pop();
              }
            ),
          ]
        );
      } else {
        return ListTile(
          title: Text('Log in',
            style: Theme.of(context).textTheme.title
              .merge(TextStyle(color: _isSelected(item: ContentItem.account, route: AccountContentRoute.login)))
          ),
          onTap: () {
            stateStore.setAccountContentRoute(AccountContentRoute.login);
            Navigator.of(context).pop();
          }
        );
      }

    }
  );
}
