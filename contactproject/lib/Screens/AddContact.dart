import 'package:contactproject/Model/Contact.dart';
import 'package:contactproject/Providers/ContactProvider.dart';
import 'package:contactproject/Providers/ThemeProvider.dart';
import 'package:contactproject/Providers/platformprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _websiteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final platformProvider = Provider.of<PlatformProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isAndroid = platformProvider.isandroid;
    bool isDarkMode = themeProvider.isDark;

    return isAndroid
        ? Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Contact Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailIdController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Manual Validation
                  String? errorMessage;
                  if (_firstNameController.text.isEmpty) {
                    errorMessage = 'Please enter a first name';
                  } else if (_lastNameController.text.isEmpty) {
                    errorMessage = 'Please enter a last name';
                  } else if (_contactNumberController.text.isEmpty) {
                    errorMessage = 'Please enter a phone number';
                  } else if (!RegExp(r'^[0-9]{10}$')
                      .hasMatch(_contactNumberController.text)) {
                    errorMessage = 'Please enter a valid 10-digit phone number';
                  } else if (_emailIdController.text.isEmpty) {
                    errorMessage = 'Please enter an email address';
                  } else if (_emailIdController.text.isNotEmpty &&
                      !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                          .hasMatch(_emailIdController.text)) {
                    errorMessage = 'Please enter a valid email address';
                  } else if (_websiteController.text.isEmpty) {
                    errorMessage = 'Please enter a website';
                  }

                  if (errorMessage != null) {
                    // Show an alert based on platform
                    if (isAndroid) {
                      // Android Material AlertDialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Validation Error'),
                            content: Text(errorMessage ?? ''),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // iOS CupertinoAlertDialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text('Validation Error'),
                            content: Text(errorMessage ?? ''),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // If all fields are valid, save the contact
                    Contact newContact = Contact(
                      _firstNameController.text,
                      _lastNameController.text,
                      _contactNumberController.text,
                      _emailIdController.text,
                      _websiteController.text,
                    );
                    contactProvider.addContact(data: newContact);
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _contactNumberController.clear();
                    _emailIdController.clear();
                    _websiteController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact saved successfully!')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(
                  child: Text('Save Contact',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        : CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Add Contact'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoTextField(
                controller: _firstNameController,
                placeholder: 'First Name',
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _lastNameController,
                placeholder: 'Last Name',
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _contactNumberController,
                placeholder: 'Phone Number',
                keyboardType: TextInputType.phone,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _emailIdController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _websiteController,
                placeholder: 'Website',
                keyboardType: TextInputType.url,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: CupertinoColors.activeBlue,
                  child: const Text("Save Contact"),
                  onPressed: () {
                    // Manual Validation
                    String? errorMessage;
                    if (_firstNameController.text.isEmpty) {
                      errorMessage = 'Please enter a first name';
                    } else if (_lastNameController.text.isEmpty) {
                      errorMessage = 'Please enter a last name';
                    } else if (_contactNumberController.text.isEmpty) {
                      errorMessage = 'Please enter a phone number';
                    } else if (!RegExp(r'^[0-9]{10}$')
                        .hasMatch(_contactNumberController.text)) {
                      errorMessage = 'Please enter a valid 10-digit phone number';
                    } else if (_emailIdController.text.isEmpty) {
                      errorMessage = 'Please enter an email address';
                    } else if (_emailIdController.text.isNotEmpty &&
                        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                            .hasMatch(_emailIdController.text)) {
                      errorMessage = 'Please enter a valid email address';
                    } else if (_websiteController.text.isEmpty) {
                      errorMessage = 'Please enter a website';
                    }

                    if (errorMessage != null) {
                      // Show an alert based on platform
                      if (isAndroid) {
                        // Android Material AlertDialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Validation Error'),
                              content: Text(errorMessage ?? ''),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // iOS CupertinoAlertDialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('Validation Error'),
                              content: Text(errorMessage ?? ''),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // If all fields are valid, save the contact
                      Contact newContact = Contact(
                        _firstNameController.text,
                        _lastNameController.text,
                        _contactNumberController.text,
                        _emailIdController.text,
                        _websiteController.text,
                      );
                      contactProvider.addContact(data: newContact);
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _contactNumberController.clear();
                      _emailIdController.clear();
                      _websiteController.clear();
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}