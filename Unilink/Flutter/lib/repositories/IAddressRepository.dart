import 'package:unilink_flutter_app/models/district_model.dart';
import 'package:unilink_flutter_app/models/province_model.dart';

abstract class IAddressRepository {
  Future<List<Province>> getAllProvince();
  Future<List<District>> getDistrictList(String code);
}
