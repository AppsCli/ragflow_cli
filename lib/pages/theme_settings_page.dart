import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../providers/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.themeSettings),
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
    switch (scheme) {
      case ColorSchemeType.blue:
        return Strings.colorSchemeBlue;
      case ColorSchemeType.green:
        return Strings.colorSchemeGreen;
      case ColorSchemeType.purple:
        return Strings.colorSchemePurple;
      case ColorSchemeType.orange:
        return Strings.colorSchemeOrange;
      case ColorSchemeType.red:
        return Strings.colorSchemeRed;
      case ColorSchemeType.teal:
        return Strings.colorSchemeTeal;
      case ColorSchemeType.pink:
        return Strings.colorSchemePink;
      case ColorSchemeType.indigo:
        return Strings.colorSchemeIndigo;
      case ColorSchemeType.brown:
        return Strings.colorSchemeBrown;
      case ColorSchemeType.cyan:
        return Strings.colorSchemeCyan;
    }
  }
}
