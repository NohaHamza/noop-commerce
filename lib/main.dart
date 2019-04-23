// General Dart and Flutter packages
import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/gestures.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:email_validator/email_validator.dart';

// Mezzanine API client package
import 'package:mezzanine_dart_client/api.dart';

// MobX state management
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:shop_app_with_mezzanine/state_store.dart';

// App components
import 'package:shop_app_with_mezzanine/config.dart';
import 'package:shop_app_with_mezzanine/components/general_data.dart';
import 'package:shop_app_with_mezzanine/components/content_navigation.dart';
part 'package:shop_app_with_mezzanine/components/app_title.dart';
part 'package:shop_app_with_mezzanine/components/menu_navigation.dart';
part 'package:shop_app_with_mezzanine/components/bottom_navigation.dart';
part 'package:shop_app_with_mezzanine/components/progress_indicator.dart';
part 'package:shop_app_with_mezzanine/components/shop_products_grid.dart';
part 'package:shop_app_with_mezzanine/components/products_loading_indicator.dart';
part 'package:shop_app_with_mezzanine/components/products_loading_error.dart';
part 'package:shop_app_with_mezzanine/components/settings_loading_indicator.dart';
part 'package:shop_app_with_mezzanine/components/cart_drawer.dart';
part 'package:shop_app_with_mezzanine/components/form_widgets.dart';

// App routers
part 'package:shop_app_with_mezzanine/sections/home/home_content.dart';
part 'package:shop_app_with_mezzanine/sections/account/account_content.dart';
part 'package:shop_app_with_mezzanine/sections/favourites/favourite_content.dart';
part 'package:shop_app_with_mezzanine/sections/checkout/checkout_content.dart';

// App home section views
part 'package:shop_app_with_mezzanine/sections/home/shop_view.dart';
part 'package:shop_app_with_mezzanine/sections/home/category_view.dart';
part 'package:shop_app_with_mezzanine/sections/home/product_view.dart';
part 'package:shop_app_with_mezzanine/sections/home/product_photo_view.dart';

// App account section views
part 'package:shop_app_with_mezzanine/sections/account/login_view.dart';
part 'package:shop_app_with_mezzanine/sections/account/signup_view.dart';
part 'package:shop_app_with_mezzanine/sections/account/activate_account_view.dart';
part 'package:shop_app_with_mezzanine/sections/account/password_reset_view.dart';

// App favourite products views
part 'package:shop_app_with_mezzanine/sections/favourites/favourite_view.dart';

// App checkout section views
part 'package:shop_app_with_mezzanine/sections/checkout/checkout_steps_view.dart';

// App
part 'app.dart';

// Globals: Theme

const double appViewHeaderElevation = 1.0;
const double appTopMargin = 15.0;
const double appBottomMargin = 15.0;
const double appLeftMargin = 25.0;
const double appLeftMargin_iPhoneX = 50.0;
const double appRightMargin = 25.0;
const double appGeneralSpacing = 10.0;

const Color primaryTextColour = Colors.grey;

const Color menuItemColour = Colors.grey[700];
const Color activeMenuItemColour = Colors.black;
const Color progressIndicatorColour = Colors.grey;

const Color dropdownColour = Colors.black;
const Color dropdownHintColour = Color.fromARGB(255, 118, 118, 118);
const Color dropdownValidationColour = Color.fromARGB(255, 213, 63, 63);
const double dropdownFontSize = 16.0;
const double dropdownValidationFontSize = 12.0;
const Color dropdownBorderColour = Color.fromARGB(255, 139, 139, 139);
const Color dropdownBackgroundColour = Color.fromARGB(255, 240, 240, 240);
const double dropdownHorizontalSpacing = 11.0;

const Color checkboxColour = Colors.grey[700];
const Color radiobuttonColour = Colors.grey[700];

const LinearGradient appLinearGradient = LinearGradient(
  begin: Alignment(0.0, -1.0),
  end: Alignment(0.0, -0.4),
  colors: <Color>[Color(0xFF666666), Color(0xFF999999)],
);

const int appGeneralAnimationDuration = 500;

const double appLeftMarginStepper = 5.0;
const double appLeftMarginStepper_iPhoneX = 30.0;

// Globals: General

String siteUrl = AppConfig['Site URL'].replaceAll('/\$', '');

final StateStore stateStore = StateStore();

void initAppState() {
  stateStore.fetchUsers();
  stateStore.fetchCategories();
  stateStore.fetchProducts();
  stateStore.fetchSettings();
  stateStore.fetchSystemSettings();
}

// Main

void main() {
  defaultApiClient = new ApiClient(AppConfig['Site URL'] + '/api', {
    'API Secret Key': new ApiKeyAuth('header', 'Api-Secret-Key', AppConfig['API Secret Key']),
    'API Token': new ApiKeyAuth('header', 'Api-Token', AppConfig['API Token'])
  });

  initAppState();

  runApp(MezzanineShopApp());
}

class MezzanineShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: new App(),
      ),
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}

