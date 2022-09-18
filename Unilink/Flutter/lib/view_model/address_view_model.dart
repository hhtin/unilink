import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/province_model.dart';
import 'package:unilink_flutter_app/repositories/Impl/AddressRepository.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressRepository _addressRepository = AddressRepository();
  List<ProvinceViewModel> provinceList = [];

  Future<List<ProvinceViewModel>> getAllProvince() async {
    provinceList.clear();
    provinceList.add(ProvinceViewModel(Province(
        name: "--Tỉnh--",
        code: -1,
        division_type: "--Tỉnh--",
        phone_code: -1)));
    try {
      List<Province> provinces = await _addressRepository.getAllProvince();
      provinces
          .forEach((element) => provinceList.add(ProvinceViewModel(element)));
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
    return provinceList;
  }
}

class ProvinceViewModel {
  final Province province;
  ProvinceViewModel(this.province);
}
