import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

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
            title: Text(l10n.chinese),
            value: const Locale('zh'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              localeProvider.setLocale(value);
            },
          ),
          const Divider(),
          RadioListTile<Locale?>(
            title: Text(l10n.english),
            value: const Locale('en'),
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
    
    if (systemLocale.languageCode == 'zh') {
      return AppLocalizations.of(context)!.chinese;
    } else {
      return AppLocalizations.of(context)!.english;
    }
  }
}
