import 'package:http/http.dart' as http;

class AgoraTokenService {
  Future<String> getToken(String channelName) async {
    Uri url = Uri.parse("https://agora-gen-token.herokuapp.com/agora/token/" + channelName);
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final token = response.body;
      return token;
    } else {
      throw Exception("Unable to perform request");
    }
  }
}
