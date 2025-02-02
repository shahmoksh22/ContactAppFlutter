import 'package:contactproject/Providers/ContactProvider.dart';
import 'package:contactproject/Providers/ThemeProvider.dart';
import 'package:contactproject/Providers/platformprovider.dart';
import 'package:contactproject/Screens/ContactDetailsPage.dart';
import 'package:contactproject/Screens/HiddenContactDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hiddencontactlist extends StatefulWidget {
  const Hiddencontactlist({super.key});

  @override
  State<Hiddencontactlist> createState() => _HiddencontactlistpageState();
}

class _HiddencontactlistpageState extends State<Hiddencontactlist> {
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final contacts = contactProvider.hideContacts;
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
          "Hidden Contact List",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
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
                    builder: (context) => Hiddencontactdetails(contact: contact),
                  ),
                );
              },
            ),
          );
        },
      ),
    )
        : CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Hidden Contact List",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
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
                        builder: (context) => Hiddencontactdetails(contact: contact),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}