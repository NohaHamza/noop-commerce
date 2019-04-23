part of 'main.dart';

class App extends StatelessWidget {
  Widget _buildOffstageContent(void Function(SnackBar) showMessage, ContentItem contentItem) {
    return Offstage(
      offstage: stateStore.currentContentItem != contentItem,
      child: contentItem == ContentItem.home ? HomeContent(showMessage)
      : contentItem == ContentItem.favourite ? FavouriteContent(showMessage)
      : contentItem == ContentItem.checkout ? CheckoutContent(showMessage)
      : contentItem == ContentItem.account ? AccountContent(showMessage)
      : Container(),
    );
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      void _showMessage(SnackBar message) {
        Scaffold.of(context).showSnackBar(message);
      }

      return Scaffold(
        appBar: AppBar(
          title: AppTitle(),
          // @todo:
          // actions: <Widget>[
          //   IconButton(
          //     tooltip: 'Search',
          //     icon: const Icon(Icons.search),
          //   ),
          // ],
        ),
        drawer: MenuNavigation(_showMessage),
        body: Stack(children: <Widget>[
          _buildOffstageContent(_showMessage, ContentItem.home),
          _buildOffstageContent(_showMessage, ContentItem.favourite),
          _buildOffstageContent(_showMessage, ContentItem.checkout),
          _buildOffstageContent(_showMessage, ContentItem.account),
        ]),
        bottomNavigationBar: BottomNavigation(_showMessage),
      );
    }
  );
}
