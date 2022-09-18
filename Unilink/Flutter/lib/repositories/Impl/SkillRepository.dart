import 'package:unilink_flutter_app/models/skill.dart';
import 'package:unilink_flutter_app/repositories/ISkillRepository.dart';
import 'package:unilink_flutter_app/service/skill_service.dart';

class SkillRepository implements ISkillRepository {
  final SkillService _skillService = SkillService();
  @override
  Future<List<Skill>> getAll() async {
    try {
      return await _skillService.getAll();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
