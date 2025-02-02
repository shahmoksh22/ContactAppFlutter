import 'dart:io';
import 'package:contactproject/Model/Contact.dart';
import 'package:contactproject/Providers/ContactProvider.dart';
import 'package:contactproject/Providers/ThemeProvider.dart';
import 'package:contactproject/Providers/platformprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Hiddencontactdetails extends StatelessWidget {
  final Contact contact;

  Hiddencontactdetails({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<PlatformProvider>(context);
    bool isAndroid = themeProvider.isandroid;
    return isAndroid
    // Android version: Row layout for buttons
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Hidden Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Name
            Text(
              'Name: ${contact.firstName} ${contact.lastName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            // Contact Phone
            Text(
              'Phone: ${contact.contactNumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Contact Email (Nullable)
            contact.emailId != null
                ? Text(
              'Email: ${contact.emailId}',
              style: TextStyle(fontSize: 18),
            )
                : Container(),
            SizedBox(height: 10),
            // Contact Website (Nullable)
            contact.website != null
                ? Text(
              'Website: ${contact.website}',
              style: TextStyle(fontSize: 18),
            )
                : Container(),
            SizedBox(height: 20),
            // Action buttons (Call, SMS, Email, Website) in a row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Call
                IconButton(
                  onPressed: () {
                    final Uri telUri = Uri.parse('tel:${contact.contactNumber}');
                    launchUrl(telUri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.call, color: Colors.blue),
                ),
                // SMS
                IconButton(
                  onPressed: () {
                    final Uri smsUri = Uri.parse('sms:${contact.contactNumber}');
                    launchUrl(smsUri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.sms, color: Colors.blue),
                ),
                // Email (Nullable)
                contact.emailId != null
                    ? IconButton(
                  onPressed: () {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: contact.emailId,
                    );
                    launchUrl(emailUri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.email, color: Colors.blue),
                )
                    : Container(),
                // Website (Nullable)
                contact.website != null
                    ? IconButton(
                  onPressed: () {
                    String url = contact.website!;
                    if (!url.startsWith('http://') && !url.startsWith('https://')) {
                      url = 'https://$url';
                    }
                    final Uri websiteUri = Uri.parse(url);
                    launchUrl(websiteUri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(CupertinoIcons.globe, color: Colors.blue),
                )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    )
    // iOS version: Column layout for buttons
        : CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Contact Details'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Name
              Text(
                'Name: ${contact.firstName} ${contact.lastName}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              // Contact Phone
              Text(
                'Phone: ${contact.contactNumber}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              // Contact Email (Nullable)
              contact.emailId != null
                  ? Text(
                'Email: ${contact.emailId}',
                style: TextStyle(fontSize: 18),
              )
                  : Container(),
              SizedBox(height: 10),
              // Contact Website (Nullable)
              contact.website != null
                  ? Text(
                'Website: ${contact.website}',
                style: TextStyle(fontSize: 18),
              )
                  : Container(),
              SizedBox(height: 20),
              // Action buttons (Call, SMS, Email, Website) in a column
              CupertinoFormSection.insetGrouped(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      final Uri telUri = Uri.parse('tel:${contact.contactNumber}');
                      launchUrl(telUri, mode: LaunchMode.externalApplication);
                    },
                    child: CupertinoListTile(
                      leading: Icon(CupertinoIcons.phone, color: Colors.blue),
                      title: Text('Call', style: TextStyle(fontSize: 16)),
                      onTap: () {
                        final Uri telUri = Uri.parse('tel:${contact.contactNumber}');
                        launchUrl(telUri, mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      final Uri smsUri = Uri.parse('sms:${contact.contactNumber}');
                      launchUrl(smsUri, mode: LaunchMode.externalApplication);
                    },
                    child: CupertinoListTile(
                      leading: Icon(CupertinoIcons.chat_bubble, color: Colors.blue),
                      title: Text('Send SMS', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: contact.emailId,
                      );
                      launchUrl(emailUri, mode: LaunchMode.externalApplication);
                    },
                    child: CupertinoListTile(
                      leading: Icon(CupertinoIcons.mail, color: Colors.blue),
                      title: Text('Send Email', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      String url = contact.website;
                      if (!url.startsWith('http://') && !url.startsWith('https://')) {
                        url = 'https://$url';
                      }
                      final Uri websiteUri = Uri.parse(url);
                      launchUrl(websiteUri, mode: LaunchMode.externalApplication);
                    },
                    child: CupertinoListTile(
                      leading: Icon(CupertinoIcons.globe, color: Colors.blue),
                      title: Text('Visit Website', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}