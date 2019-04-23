// General Flutter packages
import 'package:tuple/tuple.dart';

// MobX state management
import 'package:mobx/mobx.dart';

// Mezzanine API client package
import 'package:mezzanine_dart_client/api.dart';

// Content navigation constants
import 'package:shop_app_with_mezzanine/components/content_navigation.dart';

part 'state_store.g.dart';

class StateStore = _StateStore with _$StateStore;

abstract class _StateStore implements Store {
  final shopUsersApi = new UsersApi();
  final shopCategoriesApi = new CategoriesApi();
  final shopProductsApi = new ProductsApi();
  final shopCartsApi = new CartsApi();
  final shopCartItemsApi = new CartitemsApi();
  final shopOrdersApi = new OrdersApi();
  final shopOrderItemsApi = new OrderitemsApi();
  final shopSettingsApi = new SettingsApi();
  final shopSystemSettingsApi = new SystemsettingsApi();

  List<User> userList = [];
  List<Category> categoryList = [];
  List<Product> productList = [];
  List<Setting> settingList = [];
  List<SystemSetting> systemSettingList = [];
  UserPasswordCheck userPasswordCheck = new UserPasswordCheck();
  User userCreate = new User();
  UserPasswordReset userPasswordReset = new UserPasswordReset();
  Cart cartCreate = new Cart();
  CartItem cartItemCreate = new CartItem();
  Order orderCreate = new Order();
  Order orderUpdate = new Order();
  OrderItem orderItemCreate = new OrderItem();
  CartBillingShipping cartBillingShipping = new CartBillingShipping();
  CartTax cartTax = new CartTax();
  CartPayment cartPayment = new CartPayment();
  OrderPlacement orderPlacement = new OrderPlacement();

  static ObservableFuture<List<User>> emptyUsersResponse =
    ObservableFuture.value([]);
  static ObservableFuture<List<Category>> emptyCategoriesResponse =
    ObservableFuture.value([]);
  static ObservableFuture<List<Product>> emptyProductsResponse =
    ObservableFuture.value([]);
  static ObservableFuture<List<Setting>> emptySettingsResponse =
    ObservableFuture.value([]);
  static ObservableFuture<List<SystemSetting>> emptySystemSettingsResponse =
    ObservableFuture.value([]);
  static ObservableFuture<UserPasswordCheck> emptyUserPasswordCheckResponse =
    ObservableFuture.value(new UserPasswordCheck());
  static ObservableFuture<User> emptyUserCreateResponse =
    ObservableFuture.value(new User());
  static ObservableFuture<UserPasswordReset> emptyUserPasswordResetResponse =
    ObservableFuture.value(new UserPasswordReset());
  static ObservableFuture<Cart> emptyCartCreateResponse =
    ObservableFuture.value(new Cart());
  static ObservableFuture<CartItem> emptyCartItemCreateResponse =
    ObservableFuture.value(new CartItem());
  static ObservableFuture<Order> emptyOrderCreateResponse =
    ObservableFuture.value(new Order());
  static ObservableFuture<Order> emptyOrderUpdateResponse =
    ObservableFuture.value(new Order());
  static ObservableFuture<OrderItem> emptyOrderItemCreateResponse =
    ObservableFuture.value(new OrderItem());
  static ObservableFuture<CartBillingShipping> emptyCartBillingShippingResponse =
    ObservableFuture.value(new CartBillingShipping());
  static ObservableFuture<CartTax> emptyCartTaxResponse =
    ObservableFuture.value(new CartTax());
  static ObservableFuture<CartPayment> emptyCartPaymentResponse =
    ObservableFuture.value(new CartPayment());
  static ObservableFuture<OrderPlacement> emptyOrderPlacementResponse =
    ObservableFuture.value(new OrderPlacement());

  @observable
  User currentUser = null;
  @observable
  bool gotoCheckout = false;
  @observable
  List<Product> favouriteList = [];
  @observable
  List<CartItem> cart = [];
  @observable
  ContentItem currentContentItem = ContentItem.home;
  @observable
  HomeContentRoute currentHomeContentRoute = HomeContentRoute.shop;
  @observable
  AccountContentRoute currentAccountContentRoute = AccountContentRoute.login;
  @observable
  FavouriteContentRoute currentFavouriteContentRoute = FavouriteContentRoute.favourite;
  @observable
  CheckoutContentRoute currentCheckoutContentRoute = CheckoutContentRoute.steps;
  @observable
  Category currentCategory = null;
  @observable
  Product currentProduct = null;

  @observable
  ObservableFuture<List<User>> fetchUsersFuture = emptyUsersResponse;
  @observable
  ObservableFuture<List<Category>> fetchCategoriesFuture = emptyCategoriesResponse;
  @observable
  ObservableFuture<List<Product>> fetchProductsFuture = emptyProductsResponse;
  @observable
  ObservableFuture<List<Setting>> fetchSettingsFuture = emptySettingsResponse;
  @observable
  ObservableFuture<List<SystemSetting>> fetchSystemSettingsFuture = emptySystemSettingsResponse;
  @observable
  ObservableFuture<UserPasswordCheck> usersCheckPasswordFuture = emptyUserPasswordCheckResponse;
  @observable
  ObservableFuture<User> usersCreateFuture = emptyUserCreateResponse;
  @observable
  ObservableFuture<UserPasswordReset> usersResetPasswordFuture = emptyUserPasswordResetResponse;
  @observable
  ObservableFuture<Order> orderCreateFuture = emptyOrderCreateResponse;
  @observable
  ObservableFuture<Order> orderUpdateFuture = emptyOrderUpdateResponse;
  @observable
  ObservableFuture<OrderItem> orderItemCreateFuture = emptyOrderItemCreateResponse;
  @observable
  ObservableFuture<Cart> cartCreateFuture = emptyCartCreateResponse;
  @observable
  ObservableFuture<CartItem> cartItemCreateFuture = emptyCartItemCreateResponse;
  @observable
  ObservableFuture<CartBillingShipping> cartBillingShippingFuture = emptyCartBillingShippingResponse;
  @observable
  ObservableFuture<CartTax> cartTaxFuture = emptyCartTaxResponse;
  @observable
  ObservableFuture<CartPayment> cartPaymentFuture = emptyCartPaymentResponse;
  @observable
  ObservableFuture<OrderPlacement> orderPlacementFuture = emptyOrderPlacementResponse;

  @computed
  bool get isLoggedIn => currentUser != null;
  @computed
  String get currentUserName =>
    currentUser.first_name != null && currentUser.last_name != null && currentUser.first_name.trim() != '' && currentUser.last_name.trim() != ''
    ? currentUser.first_name + ' ' + currentUser.last_name
    : currentUser.email != null
    ? currentUser.email
    : currentUser.username;
  @computed
  bool get hasUsersResults =>
    fetchUsersFuture != emptyUsersResponse &&
    fetchUsersFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasCategoriesResults =>
    fetchCategoriesFuture != emptyCategoriesResponse &&
    fetchCategoriesFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasProductsResults =>
    fetchProductsFuture != emptyProductsResponse &&
    fetchProductsFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasSettingsResults =>
    fetchSettingsFuture != emptySettingsResponse &&
    fetchSettingsFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasSystemSettingsResults =>
    fetchSystemSettingsFuture != emptySystemSettingsResponse &&
    fetchSystemSettingsFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasUserPasswordCheckResults =>
    usersCheckPasswordFuture != emptyUserPasswordCheckResponse &&
    usersCheckPasswordFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasUserCreateResults =>
    usersCreateFuture != emptyUserCreateResponse &&
    usersCreateFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasUserPasswordResetResults =>
    usersResetPasswordFuture != emptyUserPasswordResetResponse &&
    usersResetPasswordFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasCartCreateResults =>
    cartCreateFuture != emptyCartCreateResponse &&
    cartCreateFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasCartItemCreateResults =>
    cartItemCreateFuture != emptyCartItemCreateResponse &&
    cartItemCreateFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasCartBillingShippingResults =>
    cartBillingShippingFuture != emptyCartBillingShippingResponse &&
    cartBillingShippingFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasCartTaxResults =>
    cartTaxFuture != emptyCartTaxResponse &&
    cartTaxFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasCartPaymentResults =>
    cartPaymentFuture != emptyCartPaymentResponse &&
    cartPaymentFuture.status == FutureStatus.fulfilled;
  @computed
  bool get hasOrderPlacementResults =>
    orderPlacementFuture != emptyOrderPlacementResponse &&
    orderPlacementFuture.status == FutureStatus.fulfilled;
  
  @action
  void setCurrentUser(User user) {
    currentUser = user;
  }

  @action
  void setGotoCheckout(bool go) {
    gotoCheckout = go;
  }

  @action
  void addFavourite(Product product) {
    var newRef = favouriteList;
    newRef.add(product);
    favouriteList = newRef;
  }
  @action
  void removeFavourite(Product product) {
    var newRef = favouriteList;
    newRef.remove(product);
    favouriteList = newRef;
  }

  @action
  void addCartItem(CartItem cartItem) {
    var newRef = cart;
    newRef.add(cartItem);
    cart = newRef;
  }
  @action
  void updateCartItem(CartItem cartItem) {
    var newRef = cart;
    var listIndex = newRef.indexWhere((item) => item.sku == cartItem.sku);
    newRef[listIndex] = cartItem;
    cart = newRef;
  }
  @action
  void removeCartItem(CartItem cartItem) {
    var newRef = cart;
    newRef.remove(cartItem);
    cart = newRef;
  }
  @action
  void clearCart() {
    var newRef = cart;
    newRef = [];
    cart = newRef;
  }

  @action
  void setHomeContentRoute(HomeContentRoute contentRoute) {
    currentContentItem = ContentItem.home;
    currentHomeContentRoute = contentRoute;
  }
  @action
  void setAccountContentRoute(AccountContentRoute contentRoute) {
    currentContentItem = ContentItem.account;
    currentAccountContentRoute = contentRoute;
  }
  @action
  void setFavouriteContentRoute(FavouriteContentRoute contentRoute) {
    currentContentItem = ContentItem.favourite;
    currentFavouriteContentRoute = contentRoute;
  }
  @action
  void setCheckoutContentRoute(CheckoutContentRoute contentRoute) {
    currentContentItem = ContentItem.checkout;
    currentCheckoutContentRoute = contentRoute;
  }

  @action
  void setCurrentCategory(Category category) {
    currentCategory = category;
  }
  @action
  void setCurrentProduct(Product product) {
    currentProduct = product;
  }

  @action
  Future<List<User>> fetchUsers() async {
    userList = [];
    final future = shopUsersApi.usersList();
    fetchUsersFuture = ObservableFuture(future);
    return userList = await future;
  }

  @action
  Future<List<Category>> fetchCategories() async {
    categoryList = [];
    final future = shopCategoriesApi.categoriesList();
    fetchCategoriesFuture = ObservableFuture(future);
    return categoryList = await future;
  }

  @action
  Future<List<Product>> fetchProducts() async {
    productList = [];
    final future = shopProductsApi.productsList();
    fetchProductsFuture = ObservableFuture(future);
    return productList = await future;
  }

  @action
  Future<List<Setting>> fetchSettings() async {
    settingList = [];
    final future = shopSettingsApi.settingsList();
    fetchSettingsFuture = ObservableFuture(future);
    return settingList = await future;
  }

  @action
  Future<List<SystemSetting>> fetchSystemSettings() async {
    systemSettingList = [];
    final future = shopSystemSettingsApi.systemsettingsList();
    fetchSystemSettingsFuture = ObservableFuture(future);
    return systemSettingList = await future;
  }

  @action
  Future<UserPasswordCheck> usersCheckPassword(UserPasswordCheck data) async {
    userPasswordCheck = new UserPasswordCheck();
    final future = shopUsersApi.usersCheckPassword(data);
    usersCheckPasswordFuture = ObservableFuture(future);
    return userPasswordCheck = await future;
  }

  @action
  Future<User> usersCreate(User data) async {
    userCreate = new User();
    final future = shopUsersApi.usersCreate(data);
    usersCreateFuture = ObservableFuture(future);
    return userCreate = await future;
  }

  @action
  Future<UserPasswordReset> usersResetPassword(UserPasswordReset data) async {
    userPasswordReset = new UserPasswordReset();
    final future = shopUsersApi.usersResetPassword(data);
    usersResetPasswordFuture = ObservableFuture(future);
    return userPasswordReset = await future;
  }

  @action
  Future<Cart> cartsCreate(Cart data) async {
    cartCreate = new Cart();
    final future = shopCartsApi.cartsCreate(data);
    cartCreateFuture = ObservableFuture(future);
    return cartCreate = await future;
  }

  @action
  Future<CartItem> cartItemsCreate(CartItem data) async {
    cartItemCreate = new CartItem();
    final future = shopCartItemsApi.cartitemsCreate(data);
    cartItemCreateFuture = ObservableFuture(future);
    return cartItemCreate = await future;
  }

  @action
  Future<Order> ordersCreate(Order data) async {
    orderCreate = new Order();
    final future = shopOrdersApi.ordersCreate(data);
    orderCreateFuture = ObservableFuture(future);
    return orderCreate = await future;
  }

  @action
  Future<Order> ordersUpdate(int id, Order data) async {
    orderUpdate = new Order();
    final future = shopOrdersApi.ordersUpdate(id, data);
    orderUpdateFuture = ObservableFuture(future);
    return orderUpdate = await future;
  }

  @action
  Future<OrderItem> orderItemsCreate(OrderItem data) async {
    orderItemCreate = new OrderItem();
    final future = shopOrderItemsApi.orderitemsCreate(data);
    orderItemCreateFuture = ObservableFuture(future);
    return orderItemCreate = await future;
  }

  @action
  Future<CartBillingShipping> cartsBillingShipping(int id, CartBillingShipping data) async {
    cartBillingShipping = new CartBillingShipping();
    final future = shopCartsApi.cartsBillingShipping(id, data);
    cartBillingShippingFuture = ObservableFuture(future);
    return cartBillingShipping = await future;
  }

  @action
  Future<CartTax> cartsTax(int id, CartTax data) async {
    cartTax = new CartTax();
    final future = shopCartsApi.cartsTax(id, data);
    cartTaxFuture = ObservableFuture(future);
    return cartTax = await future;
  }

  @action
  Future<CartPayment> cartsPayment(int id, CartPayment data) async {
    cartPayment = new CartPayment();
    final future = shopCartsApi.cartsPayment(id, data);
    cartPaymentFuture = ObservableFuture(future);
    return cartPayment = await future;
  }

  @action
  Future<OrderPlacement> ordersPlacement(int id, OrderPlacement data) async {
    orderPlacement = new OrderPlacement();
    final future = shopCartsApi.cartsOrderPlacement(id, data);
    orderPlacementFuture = ObservableFuture(future);
    return orderPlacement = await future;
  }
}
