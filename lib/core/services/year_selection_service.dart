import 'package:shared_preferences/shared_preferences.dart';

class YearSelectionService {
  static const String _selectedYearIdKey = 'selected_academic_year_id';
  static const String _selectedYearCodeKey = 'selected_academic_year_code';

  Future<void> saveSelectedYear(int yearId, String yearCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedYearIdKey, yearId);
    await prefs.setString(_selectedYearCodeKey, yearCode);
  }

  Future<int?> getSelectedYearId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedYearIdKey);
  }

  Future<String?> getSelectedYearCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedYearCodeKey);
  }

  Future<bool> hasSelectedYear() async {
    final yearId = await getSelectedYearId();
    return yearId != null;
  }

  Future<void> clearSelectedYear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedYearIdKey);
    await prefs.remove(_selectedYearCodeKey);
  }
}
