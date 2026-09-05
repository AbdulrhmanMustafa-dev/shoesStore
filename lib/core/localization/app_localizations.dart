import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('ar'), Locale('fr')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  String get languageName => _text('languageName');
  String get accountSettings => _text('accountSettings');
  String get profileInfo => _text('profileInfo');
  String get account => _text('account');
  String get appSettings => _text('appSettings');
  String get language => _text('language');
  String get english => _text('english');
  String get arabic => _text('arabic');
  String get french => _text('french');
  String get deleteAccount => _text('deleteAccount');
  String get cancel => _text('cancel');
  String get delete => _text('delete');
  String get darkMode => _text('darkMode');
  String get enableFaceId => _text('enableFaceId');
  String get enablePushNotifications => _text('enablePushNotifications');
  String get enableLocationServices => _text('enableLocationServices');
  String get notificationSetting => _text('notificationSetting');
  String get shippingAddress => _text('shippingAddress');
  String get paymentInfo => _text('paymentInfo');
  String get helloAgain => _text('helloAgain');
  String get welcomeBack => _text('welcomeBack');
  String get emailAddress => _text('emailAddress');
  String get password => _text('password');
  String get recoveryPassword => _text('recoveryPassword');
  String get signIn => _text('signIn');
  String get signInWithGoogle => _text('signInWithGoogle');
  String get noAccount => _text('noAccount');
  String get signUpForFree => _text('signUpForFree');
  String get pleaseEnterEmailPassword => _text('pleaseEnterEmailPassword');
  String get createAccount => _text('createAccount');
  String get createAccountTogether => _text('createAccountTogether');
  String get yourName => _text('yourName');
  String get register => _text('register');
  String get popularShoes => _text('popularShoes');
  String get newArrivals => _text('newArrivals');
  String get lookingForShoes => _text('lookingForShoes');
  String get search => _text('search');
  String get filters => _text('filters');
  String get apply => _text('apply');
  String get reset => _text('reset');
  String get cart => _text('cart');
  String get checkout => _text('checkout');
  String get orders => _text('orders');
  String get favorites => _text('favorites');
  String get notifications => _text('notifications');
  String get getStarted => _text('getStarted');
  String get next => _text('next');
  String get onboardingTitle1 => _text('onboardingTitle1');
  String get onboardingBody1 => _text('onboardingBody1');
  String get onboardingTitle2 => _text('onboardingTitle2');
  String get onboardingBody2 => _text('onboardingBody2');
  String get onboardingTitle3 => _text('onboardingTitle3');
  String get onboardingBody3 => _text('onboardingBody3');
  String get deleteAccountQuestion => _text('deleteAccountQuestion');
  String get deleteAccountError => _text('deleteAccountError');
  String get profileUpdated => _text('profileUpdated');
  String get noEmailLinked => _text('noEmailLinked');
  String get userName => _text('userName');
  String get error => _text('error');
  String get cartEmpty => _text('cartEmpty');
  String get noShoesFound => _text('noShoesFound');
  String get recentSearches => _text('recentSearches');
  String get gender => _text('gender');
  String get size => _text('size');
  String get price => _text('price');
  String get contactInformation => _text('contactInformation');
  String get address => _text('address');
  String get paymentMethod => _text('paymentMethod');
  String get noFavorites => _text('noFavorites');
  String get noOrders => _text('noOrders');
  String get noNotifications => _text('noNotifications');
  String get clearAll => _text('clearAll');
  String get generalNotification => _text('generalNotification');
  String get sound => _text('sound');
  String get vibrate => _text('vibrate');
  String get specialOffers => _text('specialOffers');
  String get promoDiscount => _text('promoDiscount');
  String get payments => _text('payments');
  String get phone => _text('phone');
  String get save => _text('save');
  String get editPhoneNumber => _text('editPhoneNumber');
  String get enterPhoneNumber => _text('enterPhoneNumber');
  String get securePayment => _text('securePayment');
  String get summary => _text('summary');
  String get total => _text('total');
  String get noNewProducts => _text('noNewProducts');
  String get noPopularProducts => _text('noPopularProducts');

  String _text(String key) =>
      _values[locale.languageCode]?[key] ?? _values['en']![key]!;

  static const _values = <String, Map<String, String>>{
    'en': {
      'languageName': 'English',
      'accountSettings': 'Account & Settings',
      'profileInfo': 'Profile Info',
      'account': 'Account',
      'appSettings': 'App Settings',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'french': 'French',
      'deleteAccount': 'Delete Account',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'darkMode': 'Dark Mode',
      'enableFaceId': 'Enable Face ID For Log In',
      'enablePushNotifications': 'Enable Push Notifications',
      'enableLocationServices': 'Enable Location Services',
      'notificationSetting': 'Notification Setting',
      'shippingAddress': 'Shipping Address',
      'paymentInfo': 'Payment Info',
      'helloAgain': 'Hello Again!',
      'welcomeBack': "Welcome Back You've Been Missed!",
      'emailAddress': 'Email Address',
      'password': 'Password',
      'recoveryPassword': 'Recovery Password',
      'signIn': 'Sign In',
      'signInWithGoogle': 'Sign in with Google',
      'noAccount': "Don't Have An Account? ",
      'signUpForFree': 'Sign Up For Free',
      'pleaseEnterEmailPassword': 'Please enter email and password',
      'createAccount': 'Create Account',
      'createAccountTogether': "Let's Create Account Together",
      'yourName': 'Your Name',
      'register': 'Register',
      'popularShoes': 'Popular Shoes',
      'newArrivals': 'New Arrivals',
      'lookingForShoes': 'Looking for shoes',
      'search': 'Search',
      'filters': 'Filters',
      'apply': 'Apply',
      'reset': 'Reset',
      'cart': 'Cart',
      'checkout': 'Checkout',
      'orders': 'Orders',
      'favorites': 'Favorites',
      'notifications': 'Notifications',
      'getStarted': 'Get Started',
      'next': 'Next',
      'onboardingTitle1': 'Start Journey\nWith Nike',
      'onboardingBody1': 'Smart, Gorgeous & Fashionable\nCollection',
      'onboardingTitle2': 'Follow Latest\nStyle Shoes',
      'onboardingBody2':
          'There Are Many Beautiful And\nAttractive Shoes For You',
      'onboardingTitle3': 'Summer Shoes\nNike 2022',
      'onboardingBody3': 'Find your perfect style for every day',
      'deleteAccountQuestion':
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
      'deleteAccountError':
          'Error: Please log in again before deleting your account.',
      'profileUpdated': 'Profile updated successfully!',
      'noEmailLinked': 'No email linked',
      'userName': 'User Name',
      'error': 'Error',
      'cartEmpty': 'Your Cart is Empty',
      'noShoesFound': 'No shoes found matching your filters!',
      'recentSearches': 'Recent Searches',
      'gender': 'Gender',
      'size': 'Size',
      'price': 'Price',
      'contactInformation': 'Contact Information',
      'address': 'Address',
      'paymentMethod': 'Payment Method',
      'noFavorites': 'No Favorite Shoes Yet!',
      'noOrders': 'No orders yet!',
      'noNotifications': 'No Notifications Yet!',
      'clearAll': 'Clear All',
      'generalNotification': 'General Notification',
      'sound': 'Sound',
      'vibrate': 'Vibrate',
      'specialOffers': 'Special Offers',
      'promoDiscount': 'Promo & Discount',
      'payments': 'Payments',
      'phone': 'Phone',
      'save': 'Save',
      'editPhoneNumber': 'Edit Phone Number',
      'enterPhoneNumber': 'Enter phone number',
      'securePayment': 'Secure payment',
      'summary': 'Summary',
      'total': 'Total',
      'noNewProducts': 'No new products for this brand.',
      'noPopularProducts': 'No popular products for this brand.',
    },
    'ar': {
      'languageName': 'العربية',
      'accountSettings': 'الحساب والإعدادات',
      'profileInfo': 'معلومات الملف الشخصي',
      'account': 'الحساب',
      'appSettings': 'إعدادات التطبيق',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'french': 'الفرنسية',
      'deleteAccount': 'حذف الحساب',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'darkMode': 'الوضع الداكن',
      'enableFaceId': 'تفعيل Face ID لتسجيل الدخول',
      'enablePushNotifications': 'تفعيل الإشعارات الفورية',
      'enableLocationServices': 'تفعيل خدمات الموقع',
      'notificationSetting': 'إعدادات الإشعارات',
      'shippingAddress': 'عنوان الشحن',
      'paymentInfo': 'معلومات الدفع',
      'helloAgain': 'مرحباً بعودتك!',
      'welcomeBack': 'اشتقنا إليك',
      'emailAddress': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'recoveryPassword': 'استعادة كلمة المرور',
      'signIn': 'تسجيل الدخول',
      'signInWithGoogle': 'تسجيل الدخول بواسطة Google',
      'noAccount': 'ليس لديك حساب؟ ',
      'signUpForFree': 'أنشئ حساباً مجاناً',
      'pleaseEnterEmailPassword': 'يرجى إدخال البريد الإلكتروني وكلمة المرور',
      'createAccount': 'إنشاء حساب',
      'createAccountTogether': 'لننشئ حسابك معاً',
      'yourName': 'اسمك',
      'register': 'تسجيل',
      'popularShoes': 'الأحذية الشائعة',
      'newArrivals': 'وصل حديثاً',
      'lookingForShoes': 'ابحث عن حذائك',
      'search': 'بحث',
      'filters': 'الفلاتر',
      'apply': 'تطبيق',
      'reset': 'إعادة تعيين',
      'cart': 'السلة',
      'checkout': 'الدفع',
      'orders': 'الطلبات',
      'favorites': 'المفضلة',
      'notifications': 'الإشعارات',
      'getStarted': 'ابدأ الآن',
      'next': 'التالي',
      'onboardingTitle1': 'ابدأ رحلتك\nمع Nike',
      'onboardingBody1': 'تشكيلة ذكية وأنيقة\nوعصرية',
      'onboardingTitle2': 'تابع أحدث\nأحذية الموضة',
      'onboardingBody2': 'أحذية جميلة وجذابة\nلك',
      'onboardingTitle3': 'أحذية الصيف\nNike 2022',
      'onboardingBody3': 'اعثر على أسلوبك المثالي كل يوم',
      'deleteAccountQuestion':
          'هل أنت متأكد من حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء.',
      'deleteAccountError': 'خطأ: يرجى تسجيل الدخول مجدداً قبل حذف حسابك.',
      'profileUpdated': 'تم تحديث الملف الشخصي بنجاح!',
      'noEmailLinked': 'لا يوجد بريد إلكتروني مرتبط',
      'userName': 'اسم المستخدم',
      'error': 'خطأ',
      'cartEmpty': 'سلتك فارغة',
      'noShoesFound': 'لم يتم العثور على أحذية تطابق الفلاتر!',
      'recentSearches': 'عمليات البحث الأخيرة',
      'gender': 'النوع',
      'size': 'المقاس',
      'price': 'السعر',
      'contactInformation': 'معلومات التواصل',
      'address': 'العنوان',
      'paymentMethod': 'طريقة الدفع',
      'noFavorites': 'لا توجد أحذية مفضلة بعد!',
      'noOrders': 'لا توجد طلبات بعد!',
      'noNotifications': 'لا توجد إشعارات بعد!',
      'clearAll': 'مسح الكل',
      'generalNotification': 'الإشعارات العامة',
      'sound': 'الصوت',
      'vibrate': 'الاهتزاز',
      'specialOffers': 'العروض الخاصة',
      'promoDiscount': 'العروض والخصومات',
      'payments': 'المدفوعات',
      'phone': 'الهاتف',
      'save': 'حفظ',
      'editPhoneNumber': 'تعديل رقم الهاتف',
      'enterPhoneNumber': 'أدخل رقم الهاتف',
      'securePayment': 'دفع آمن',
      'summary': 'الملخص',
      'total': 'الإجمالي',
      'noNewProducts': 'لا توجد منتجات حديثة لهذه الماركة.',
      'noPopularProducts': 'لا توجد منتجات شائعة لهذه الماركة.',
    },
    'fr': {
      'languageName': 'Français',
      'accountSettings': 'Compte et paramètres',
      'profileInfo': 'Informations du profil',
      'account': 'Compte',
      'appSettings': "Paramètres de l'application",
      'language': 'Langue',
      'english': 'Anglais',
      'arabic': 'Arabe',
      'french': 'Français',
      'deleteAccount': 'Supprimer le compte',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'darkMode': 'Mode sombre',
      'enableFaceId': 'Activer Face ID',
      'enablePushNotifications': 'Activer les notifications push',
      'enableLocationServices': 'Activer les services de localisation',
      'notificationSetting': 'Paramètres des notifications',
      'shippingAddress': 'Adresse de livraison',
      'paymentInfo': 'Informations de paiement',
      'helloAgain': 'Bonjour !',
      'welcomeBack': 'Vous nous avez manqué !',
      'emailAddress': 'Adresse e-mail',
      'password': 'Mot de passe',
      'recoveryPassword': 'Récupérer le mot de passe',
      'signIn': 'Se connecter',
      'signInWithGoogle': 'Se connecter avec Google',
      'noAccount': "Pas encore de compte ? ",
      'signUpForFree': "S'inscrire gratuitement",
      'pleaseEnterEmailPassword': "Saisissez l'e-mail et le mot de passe",
      'createAccount': 'Créer un compte',
      'createAccountTogether': 'Créons votre compte ensemble',
      'yourName': 'Votre nom',
      'register': "S'inscrire",
      'popularShoes': 'Chaussures populaires',
      'newArrivals': 'Nouveautés',
      'lookingForShoes': 'Rechercher des chaussures',
      'search': 'Rechercher',
      'filters': 'Filtres',
      'apply': 'Appliquer',
      'reset': 'Réinitialiser',
      'cart': 'Panier',
      'checkout': 'Paiement',
      'orders': 'Commandes',
      'favorites': 'Favoris',
      'notifications': 'Notifications',
      'getStarted': 'Commencer',
      'next': 'Suivant',
      'onboardingTitle1': 'Commencez votre voyage\navec Nike',
      'onboardingBody1': 'Collection élégante, intelligente\net tendance',
      'onboardingTitle2': 'Suivez les dernières\nchaussures tendance',
      'onboardingBody2': 'De belles chaussures\npour vous',
      'onboardingTitle3': "Chaussures d'été\nNike 2022",
      'onboardingBody3': 'Trouvez votre style idéal chaque jour',
      'deleteAccountQuestion':
          'Voulez-vous vraiment supprimer définitivement votre compte ? Cette action est irréversible.',
      'deleteAccountError':
          'Erreur : reconnectez-vous avant de supprimer votre compte.',
      'profileUpdated': 'Profil mis à jour !',
      'noEmailLinked': 'Aucun e-mail associé',
      'userName': "Nom d'utilisateur",
      'error': 'Erreur',
      'cartEmpty': 'Votre panier est vide',
      'noShoesFound': 'Aucune chaussure ne correspond à vos filtres !',
      'recentSearches': 'Recherches récentes',
      'gender': 'Genre',
      'size': 'Taille',
      'price': 'Prix',
      'contactInformation': 'Coordonnées',
      'address': 'Adresse',
      'paymentMethod': 'Mode de paiement',
      'noFavorites': "Aucune chaussure favorite pour l'instant !",
      'noOrders': 'Aucune commande pour le moment !',
      'noNotifications': 'Aucune notification pour le moment !',
      'clearAll': 'Tout effacer',
      'generalNotification': 'Notification générale',
      'sound': 'Son',
      'vibrate': 'Vibration',
      'specialOffers': 'Offres spéciales',
      'promoDiscount': 'Promotions et réductions',
      'payments': 'Paiements',
      'phone': 'Téléphone',
      'save': 'Enregistrer',
      'editPhoneNumber': 'Modifier le numéro de téléphone',
      'enterPhoneNumber': 'Saisissez le numéro de téléphone',
      'securePayment': 'Paiement sécurisé',
      'summary': 'Résumé',
      'total': 'Total',
      'noNewProducts': 'Aucun nouveau produit pour cette marque.',
      'noPopularProducts': 'Aucun produit populaire pour cette marque.',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
