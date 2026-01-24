import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  /// 获取语言在其自身语言中的名称
  static String _getLanguageNativeName(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        if (locale.countryCode == 'TW') {
          return '繁體中文';
        }
        return '中文';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'it':
        return 'Italiano';
      case 'ru':
        return 'Русский';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
      ),
      body: ListView(
        children: [
          RadioListTile<Locale?>(
            title: Text(l10n.followSystem),
            subtitle: Text(_getSystemLanguageName(context)),
            value: null,
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('zh'))),
            value: const Locale('zh'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('en'))),
            value: const Locale('en'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('zh', 'TW'))),
            value: const Locale('zh', 'TW'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('ja'))),
            value: const Locale('ja'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('ko'))),
            value: const Locale('ko'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('de'))),
            value: const Locale('de'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('es'))),
            value: const Locale('es'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('fr'))),
            value: const Locale('fr'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('it'))),
            value: const Locale('it'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('ru'))),
            value: const Locale('ru'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(_getLanguageNativeName(const Locale('ar'))),
            value: const Locale('ar'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
        ],
      ),
    );
  }

  String _getSystemLanguageName(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final systemLocale = localeProvider.systemLocale;
    // 使用语言自身的名称显示
    return _getLanguageNativeName(systemLocale);
  }
}
