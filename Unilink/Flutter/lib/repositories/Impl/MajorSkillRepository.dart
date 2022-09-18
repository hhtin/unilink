import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/models/major_skill.dart';
import 'package:unilink_flutter_app/repositories/IMajorSkillRepository.dart';
import 'package:unilink_flutter_app/service/major_skill_service.dart';

class MajorSkillRepository implements IMajorSkillRepository {
  final MajorSkillService _majorService = MajorSkillService();
  @override
  Future<List<MajorSkill>> getAll() async {
    try {
      return await _majorService.getAll();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
