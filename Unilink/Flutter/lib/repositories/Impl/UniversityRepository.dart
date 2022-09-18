import 'package:unilink_flutter_app/models/university.dart';
import 'package:unilink_flutter_app/repositories/IUniversityRepository.dart';
import 'package:unilink_flutter_app/service/university_service.dart';

class UniversityRepository implements IUniversityRepository {
  UniversityService service = UniversityService();
  @override
  Future<List<University>> getAll() async {
    try {
      return await service.getAll();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
