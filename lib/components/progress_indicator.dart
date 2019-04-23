part of '../main.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(appGeneralSpacing),
      child: SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColour)
        )
      ),
    );
  }
}
