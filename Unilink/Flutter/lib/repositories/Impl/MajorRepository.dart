import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/repositories/IMajorRepository.dart';
import 'package:unilink_flutter_app/service/major_service.dart';

class MajorRepository implements IMajorRepository {
  final MajorService _majorService = MajorService();
  @override
  Future<List<Major>> getAll() async {
    try {
      return await _majorService.getAll();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
