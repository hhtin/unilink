import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/skill.dart';
import 'package:unilink_flutter_app/repositories/Impl/SkillRepository.dart';

class SkillListViewModel extends ChangeNotifier {
  final SkillRepository _skillRepository = SkillRepository();
  List<SkillViewModel> skillList = [];
  Future<void> getAll() async {
    try {
      if (skillList.isEmpty) {
        List<Skill> skills = await _skillRepository.getAll();
        skillList.clear();
        skills.forEach((element) => skillList.add(SkillViewModel(element)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getSkillByMajorId() async {
    try {
      if (skillList.isEmpty) {
        List<Skill> skills = await _skillRepository.getAll();
        skillList.clear();
        skills.forEach((element) => skillList.add(SkillViewModel(element)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class SkillViewModel {
  final Skill skill;
  SkillViewModel(this.skill);
}
