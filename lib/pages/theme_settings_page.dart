import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.themeSettings),
      ),
      body: ListView(
        children: [
          ...ColorSchemeType.values.map((scheme) {
            final isSelected = themeProvider.colorScheme == scheme;
            final color = _getSchemeColor(scheme);
            final name = _getLocalizedSchemeName(context, scheme);

            return Column(
              children: [
                RadioListTile<ColorSchemeType>(
                  title: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(name),
                    ],
                  ),
                  value: scheme,
                  groupValue: themeProvider.colorScheme,
                  onChanged: (ColorSchemeType? value) {
                    if (value != null) {
                      themeProvider.setColorScheme(value);
                    }
                  },
                ),
                const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Color _getSchemeColor(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.blue:
        return Colors.blue;
      case ColorSchemeType.green:
        return Colors.green;
      case ColorSchemeType.purple:
        return Colors.purple;
      case ColorSchemeType.orange:
        return Colors.orange;
      case ColorSchemeType.red:
        return Colors.red;
      case ColorSchemeType.teal:
        return Colors.teal;
      case ColorSchemeType.pink:
        return Colors.pink;
      case ColorSchemeType.indigo:
        return Colors.indigo;
      case ColorSchemeType.brown:
        return Colors.brown;
      case ColorSchemeType.cyan:
        return Colors.cyan;
    }
  }

  String _getLocalizedSchemeName(BuildContext context, ColorSchemeType scheme) {
    final l10n = AppLocalizations.of(context)!;
    switch (scheme) {
      case ColorSchemeType.blue:
        return l10n.colorSchemeBlue;
      case ColorSchemeType.green:
        return l10n.colorSchemeGreen;
      case ColorSchemeType.purple:
        return l10n.colorSchemePurple;
      case ColorSchemeType.orange:
        return l10n.colorSchemeOrange;
      case ColorSchemeType.red:
        return l10n.colorSchemeRed;
      case ColorSchemeType.teal:
        return l10n.colorSchemeTeal;
      case ColorSchemeType.pink:
        return l10n.colorSchemePink;
      case ColorSchemeType.indigo:
        return l10n.colorSchemeIndigo;
      case ColorSchemeType.brown:
        return l10n.colorSchemeBrown;
      case ColorSchemeType.cyan:
        return l10n.colorSchemeCyan;
    }
  }
}
