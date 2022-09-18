import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/models/major_skill.dart';
import 'package:unilink_flutter_app/repositories/Impl/MajorRepository.dart';
import 'package:unilink_flutter_app/repositories/Impl/MajorSkillRepository.dart';

class MajorListViewModel extends ChangeNotifier {
  final MajorRepository _majorRepository = MajorRepository();
  final MajorSkillRepository _majorSkillRepository = MajorSkillRepository();
  List<MajorViewModel> majorList = [];
  List<MajorSkillViewModel> majorSkillList = [];
  Future<void> getAll() async {
    try {
      if (majorList.isEmpty) {
        List<Major> majors = await _majorRepository.getAll();
        majorList.clear();
        majors.forEach((element) => majorList.add(MajorViewModel(element)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getAllMajorWithSkill() async {
    try {
      if (majorSkillList.isEmpty) {
        List<MajorSkill> majors = await _majorSkillRepository.getAll();
        majorSkillList.clear();
        majors.forEach(
            (element) => majorSkillList.add(MajorSkillViewModel(element)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class MajorViewModel {
  final Major major;
  MajorViewModel(this.major);
}

class MajorSkillViewModel {
  MajorSkill major;
  MajorSkillViewModel(this.major);
}
