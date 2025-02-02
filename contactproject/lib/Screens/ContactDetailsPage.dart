import 'dart:io';
import 'package:contactproject/Model/Contact.dart';
import 'package:contactproject/Providers/ContactProvider.dart';
import 'package:contactproject/Providers/ThemeProvider.dart';
import 'package:contactproject/Providers/platformprovider.dart';
import 'package:contactproject/Screens/EditContactPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsPage extends StatefulWidget {
  Contact contact;
  final int index;

  ContactDetailsPage({Key? key, required this.contact, required this.index}) : super(key: key);

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<PlatformProvider>(context);
    bool isAndroid = themeProvider.isandroid;
    Contact contact = widget.contact;
    return isAndroid
    // Android version: Row layout for buttons
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditContactPage(contact: widget.contact,index: widget.index,),
                ),
              ).then((result) {
                if (result != null) {
                  Provider.of<ContactProvider>(context, listen: false)
                      .updateContact(widget.index, result);
                  // Assuming you have a function to update the contact
                  Navigator.pop(context);
                }
              });
            },
          ),
          // Visibility Toggle
          IconButton(
            icon: const Icon(Icons.visibility_off),
            onPressed: () {
              Provider.of<ContactProvider>(context, listen: false).hideContact(widget.index);
              Navigator.pop(context);
            },
          ),
          // Delete Contact
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Contact'),
                    content: Text('Are you sure you want to delete this contact?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<ContactProvider>(context, listen: false)
                              .deleteContact(widget.index); // Delete the contact
                          Navigator.pop(context); // Close the dialog
                          Navigator.pop(context); // Go back to the previous screen
                        },
                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Name
            Text(
              'Name: ${widget.contact.firstName} ${widget.contact.lastName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            // Contact Phone
            Text(
              'Phone: ${widget.contact.contactNumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Contact Email (Nullable)
            widget.contact.emailId != null
                ? Text(
              'Email: ${widget.contact.emailId}',
              style: TextStyle(fontSize: 18),
            )
                : Container(),
            SizedBox(height: 10),
            // Contact Website (Nullable)
            widget.contact.website != null
                ? Text(
              'Website: ${widget.contact.website}',
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
                    final Uri telUri = Uri.parse('tel:${widget.contact.contactNumber}');
                    launchUrl(telUri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.call, color: Colors.blue),
                ),
                // SMS
                IconButton(
                  onPressed: () {
                    final Uri smsUri = Uri.parse('sms:${widget.contact.contactNumber}');
                    launchUrl(smsUri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.sms, color: Colors.blue),
                ),
                // Email (Nullable)
                widget.contact.emailId != null
                    ? IconButton(
                  onPressed: () {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: widget.contact.emailId,
                    );
                    launchUrl(emailUri, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.email, color: Colors.blue),
                )
                    : Container(),
                // Website (Nullable)
                widget.contact.website != null
                    ? IconButton(
                  onPressed: () {
                    String url = widget.contact.website!;
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Your onPressed logic for the first icon
                Provider.of<ContactProvider>(context, listen: false).hideContact(widget.index);
                Navigator.pop(context);
              },
              child: const Icon(CupertinoIcons.eye, color: Colors.blue),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditContactPage(contact: widget.contact, index: widget.index),
                  ),
                ).then((result) {
                  // Trigger a function when the EditContactPage is popped
                  if (result != null) {
                    // You can handle the result here, like updating the contact list or UI
                    // For example, if the result contains updated contact data:
                    Provider.of<ContactProvider>(context, listen: false)
                        .updateContact(widget.index, result);
                    // Assuming you have a function to update the contact
                    Navigator.pop(context);
                  }
                });
              },
              child: const Icon(CupertinoIcons.pen, color: Colors.blue),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Name
              Text(
                'Name: ${widget.contact.firstName} ${widget.contact.lastName}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              // Contact Phone
              Text(
                'Phone: ${widget.contact.contactNumber}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              // Contact Email (Nullable)
              widget.contact.emailId != null
                  ? Text(
                'Email: ${widget.contact.emailId}',
                style: TextStyle(fontSize: 18),
              )
                  : Container(),
              SizedBox(height: 10),
              // Contact Website (Nullable)
              widget.contact.website != null
                  ? Text(
                'Website: ${widget.contact.website}',
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
                  final Uri telUri = Uri.parse('tel:${widget.contact.contactNumber}');
                  launchUrl(telUri, mode: LaunchMode.externalApplication);
                },
                child: CupertinoListTile(
                  leading: Icon(CupertinoIcons.phone, color: Colors.blue),
                  title: Text('Call', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    final Uri telUri = Uri.parse('tel:${widget.contact.contactNumber}');
                    launchUrl(telUri, mode: LaunchMode.externalApplication);
                  },
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  final Uri smsUri = Uri.parse('sms:${widget.contact.contactNumber}');
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
                    path: widget.contact.emailId,
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
                  String url = widget.contact.website;
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