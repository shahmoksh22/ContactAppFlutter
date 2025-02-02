import 'package:contactproject/Providers/ThemeProvider.dart';
import 'package:contactproject/Providers/platformprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  @override
  Widget build(BuildContext context) {
    bool isAndroid = Provider.of<PlatformProvider>(context).isandroid;
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDark;

    return isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Settings",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  _buildSettingsCard(
                    title: isAndroid ? "Android " : "IOS",
                    value: isAndroid,
                    onChanged: (val) =>
                        Provider.of<PlatformProvider>(context, listen: false)
                            .changeplatform(),
                    isDarkMode: isDarkMode,
                    isCupertino: false,
                  ),
                  _buildSettingsCard(
                    title: "Change Theme",
                    value: isDarkMode,
                    onChanged: (val) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .changeTheme(),
                    isDarkMode: isDarkMode,
                    isCupertino: false,
                  ),
                ],
              ),
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
              "Settings",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildSettingsCard(
                    title: isAndroid ? "Android " : "IOS",
                    value: isAndroid,
                    onChanged: (val) =>
                        Provider.of<PlatformProvider>(context, listen: false)
                            .changeplatform(),
                    isDarkMode: isDarkMode,
                    isCupertino: true,
                  ),
                  _buildSettingsCard(
                    title: "Change Theme",
                    value: isDarkMode,
                    onChanged: (val) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .changeTheme(),
                    isDarkMode: isDarkMode,
                    isCupertino: true,
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildSettingsCard({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDarkMode,
    required bool isCupertino,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: isCupertino ? 0 : 6,
        color: isDarkMode
            ? CupertinoColors.inactiveGray
            : (isCupertino ? CupertinoColors.systemBackground : Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(title),
            trailing: isCupertino
                ? CupertinoSwitch(value: value, onChanged: onChanged)
                : Switch(value: value, onChanged: onChanged),
            onTap: () => onChanged(!value),
          ),
        ),
      ),
    );
  }
}
