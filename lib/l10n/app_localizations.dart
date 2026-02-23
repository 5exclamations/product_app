import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'market_prices': 'Market Prices',
      'products': 'Products',
      'categories': 'Categories',
      'discounts': 'Discounts',
      'settings': 'Settings',
      'search_products': 'Search products',
      'no_products_found': 'No products found',
      'price': 'Price',
      'name': 'Name',
      'market': 'Market',
      'weight': 'Weight',
      'category': 'Category',
      'sold_at': 'Sold at',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'language': 'Language',
      'sort_by': 'Sort by',
      'filter': 'Filter',
      'all_markets': 'All markets',
      'discount_percentage': 'Discount %',
    },
    'ru': {
      'market_prices': 'Цены в магазинах',
      'products': 'Продукты',
      'categories': 'Категории',
      'discounts': 'Скидки',
      'settings': 'Настройки',
      'search_products': 'Поиск продуктов',
      'no_products_found': 'Продукты не найдены',
      'price': 'Цена',
      'name': 'Название',
      'market': 'Магазин',
      'weight': 'Вес',
      'category': 'Категория',
      'sold_at': 'Продается в',
      'theme': 'Тема',
      'light': 'Светлая',
      'dark': 'Темная',
      'system': 'Системная',
      'language': 'Язык',
      'sort_by': 'Сортировка',
      'filter': 'Фильтр',
      'all_markets': 'Все магазины',
      'discount_percentage': 'Скидка %',
    },
    'az': {
      'market_prices': 'Mağaza qiymətləri',
      'products': 'Məhsullar',
      'categories': 'Kateqoriyalar',
      'discounts': 'Endirimlər',
      'settings': 'Parametrlər',
      'search_products': 'Məhsul axtar',
      'no_products_found': 'Məhsul tapılmadı',
      'price': 'Qiymət',
      'name': 'Ad',
      'market': 'Mağaza',
      'weight': 'Çəki',
      'category': 'Kateqoriya',
      'sold_at': 'Satılır',
      'theme': 'Tema',
      'light': 'İşıqlı',
      'dark': 'Qaranlıq',
      'system': 'Sistem',
      'language': 'Dil',
      'sort_by': 'Sıralama',
      'filter': 'Filtr',
      'all_markets': 'Bütün mağazalar',
      'discount_percentage': 'Endirim %',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru', 'az'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
