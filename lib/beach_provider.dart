import 'package:flutter/foundation.dart';
import 'models/beach.dart';
import 'services/database_helper.dart';

class BeachProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Beach> _beaches = [];
  List<Beach> get beaches => _beaches;

  BeachProvider() {
    loadBeaches();
  }

  Future<void> loadBeaches() async {
    _beaches = await _dbHelper.getBeaches();
    notifyListeners();
  }

  Future<void> addBeach(Beach beach) async {
    await _dbHelper.addBeach(beach);
    await loadBeaches();
  }

  Future<void> updateBeach(Beach beach) async {
    await _dbHelper.updateBeach(beach);
    await loadBeaches();
  }

  Future<void> deleteBeach(int id) async {
    await _dbHelper.deleteBeach(id);
    await loadBeaches();
  }
}
