part of '../main.dart';

class SettingsLoadingIndicator extends StatelessWidget {
  const SettingsLoadingIndicator();

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) => stateStore.fetchSettingsFuture.status == FutureStatus.pending
      ? AppProgressIndicator()
      : Container()
  );
}
