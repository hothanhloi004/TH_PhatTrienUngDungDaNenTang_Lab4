import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection của user hiện tại
  CollectionReference get _contacts {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('contacts');
  }

  // Lấy danh sách contacts (realtime)
  Stream<QuerySnapshot> getContacts() {
    return _contacts.orderBy('name').snapshots();
  }

  // Thêm contact
  Future<void> addContact(String name, String phone, String email) async {
    await _contacts.add({
      'name': name,
      'phone': phone,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Cập nhật contact
  Future<void> updateContact(
      String id, String name, String phone, String email) async {
    await _contacts.doc(id).update({
      'name': name,
      'phone': phone,
      'email': email,
    });
  }

  // Xóa contact
  Future<void> deleteContact(String id) async {
    await _contacts.doc(id).delete();
  }
}