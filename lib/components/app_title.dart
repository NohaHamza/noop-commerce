part of '../main.dart';

class AppTitle extends StatelessWidget {
  AppTitle({ this.style: null});
  TextStyle style = null;

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (stateStore.fetchSettingsFuture.status == FutureStatus.pending) {
        return Container(); // AppProgressIndicator();
      }

      Setting siteTitle = stateStore.settingList.firstWhere((setting) => setting.name == 'SITE_TITLE', orElse: () => null);
      if (siteTitle != null) {
        return Text(
          siteTitle.value, 
          style: this.style,
        );
      } else {
        return Container();
      }
    }
  );
}
