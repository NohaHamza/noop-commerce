part of '../../main.dart';

class ProductPhotoView extends StatelessWidget {
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

    List<PhotoViewGalleryPageOptions> productPhotoWidgetList = [];
    product.images.forEach((productImage) {
      var productPhotoWidget = new PhotoViewGalleryPageOptions(
        imageProvider: NetworkImage(siteMediaUrl + productImage.file),
      );
      productPhotoWidgetList.add(productPhotoWidget);
    });

    return Scaffold(
      body: Container(
        child: PhotoViewGallery(
          gaplessPlayback: true,
          loadingChild: Center(
            child: AppProgressIndicator(),
          ),
          pageOptions: productPhotoWidgetList,
          backgroundDecoration: BoxDecoration(color: progressIndicatorColour),
        )
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        child: Icon(Icons.close),
        onPressed: () {
          stateStore.setCurrentProduct(product);
          stateStore.setHomeContentRoute(HomeContentRoute.product);
        }
      ),
    );
  }
}
