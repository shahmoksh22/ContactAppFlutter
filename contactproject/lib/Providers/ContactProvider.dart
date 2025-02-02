import 'package:contactproject/Model/Contact.dart';
import 'package:flutter/material.dart';
class ContactProvider extends ChangeNotifier{
  List allContacts = [];
  List hideContacts =[];

  void addContact({required Contact data}){
    allContacts.add(data);
    notifyListeners();
  }
  void hideContact(int index){
    hideContacts.add(allContacts[index]);
    deleteContact(index);
    notifyListeners();
  }
  void updateContact(int index, Contact updatedContact) {
    allContacts[index] = updatedContact;
    notifyListeners();
  }
  void deleteContact(int index) {
    allContacts.removeAt(index);
    notifyListeners();
  }
}