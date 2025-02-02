import 'package:contactproject/Providers/ContactProvider.dart';
import 'package:contactproject/Providers/ThemeProvider.dart';
import 'package:contactproject/Providers/platformprovider.dart';
import 'package:contactproject/Screens/ContactDetailsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final contacts = contactProvider.allContacts;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final platformProvider = Provider.of<PlatformProvider>(context);

    bool isAndroid = platformProvider.isandroid;
    bool isDarkMode = themeProvider.isDark;

    return isAndroid
        ? Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        title: Text(
          "HomePage",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),

            onPressed: () async {
              LocalAuthentication localAuthentication = LocalAuthentication();

              bool isBiometricAvailable = await localAuthentication
                  .canCheckBiometrics;

              bool isDeviceSupported = await localAuthentication
                  .isDeviceSupported();

              if (isBiometricAvailable || isDeviceSupported) {
                bool isAuthenticated = await localAuthentication.authenticate(
                    localizedReason: "Please provide your authenticity");

                if (isAuthenticated == true) {
                  Navigator.of(context).pushNamed('/hidenlist');
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Authentication is wrong")
                      ));
                }
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Authentication is not supported")
                    ));
              }
            }
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/setting'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            child: ListTile(
              title: Text('${contact.firstName} ${contact.lastName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone: ${contact.contactNumber}'),
                  Text('Email: ${contact.emailId}'),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactDetailsPage(contact: contact, index: index),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addcontact'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        elevation: 6.0,
      ),
    )
        : CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "HomePage",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.lock),
              onPressed: () => Navigator.pushNamed(context, '/hidenlist'),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.settings),
              onPressed: () => Navigator.pushNamed(context, '/setting'),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return CupertinoListTile(
                  title: Text('${contact.firstName} ${contact.lastName}'),
                  subtitle: Text('Phone: ${contact.contactNumber}\nEmail: ${contact.emailId}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ContactDetailsPage(contact: contact, index: index),
                      ),
                    );
                  },
                );
              },
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(30),
                onPressed: () => Navigator.pushNamed(context, '/addcontact'),
                child: const Icon(CupertinoIcons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}