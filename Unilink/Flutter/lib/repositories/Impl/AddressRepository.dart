import 'package:unilink_flutter_app/models/district_model.dart';
import 'package:unilink_flutter_app/models/province_model.dart';
import 'package:unilink_flutter_app/service/address_service.dart';

import '../IAddressRepository.dart';

class AddressRepository implements IAddressRepository {
  AddressService addressService = new AddressService();

  @override
  Future<List<Province>> getAllProvince() async {
    return await addressService.getAllProvince();
  }

  @override
  Future<List<District>> getDistrictList(String code) async {
    return await addressService.getDistrictByProvinceCode(code);
  }
}
