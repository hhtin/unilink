import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/university.dart';
import 'package:unilink_flutter_app/repositories/Impl/UniversityRepository.dart';

class UniversityListViewModel extends ChangeNotifier {
  List<UniversityViewModel> universityList = [];
  UniversityRepository _universityRepository = UniversityRepository();
  Future<void> getAll() async {
    try {
      if (universityList.isEmpty) {
        List<University> university = await _universityRepository.getAll();
        universityList.clear();
        university.forEach(
            (element) => universityList.add(UniversityViewModel(element)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class UniversityViewModel {
  final University university;
  UniversityViewModel(this.university);
}
