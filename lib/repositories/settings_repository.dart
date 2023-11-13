import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsRepository {
  Future<Map<String, bool>> getUserSettings(User authUser) async {
    return (await FirebaseFirestore.instance.collection('user_settings').doc(authUser.uid).get())
            .data()
            ?.map((key, value) => MapEntry(key, value as bool)) ??
        {};
  }

  Future<void> updateUserSettings(User authUser, String settingName, bool value) async {
    if (!(await FirebaseFirestore.instance.collection('user_settings').doc(authUser.uid).get()).exists) {
      await FirebaseFirestore.instance.collection('user_settings').doc(authUser.uid).set({settingName: value});
    }

    await FirebaseFirestore.instance.collection('user_settings').doc(authUser.uid).update({settingName: value});
  }
}
