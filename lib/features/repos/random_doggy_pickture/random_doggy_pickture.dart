import '../repos_view.dart';

//https://dog.ceo/api/breeds/image/random

class ApiResponse {
  Future<String> randDoggyPick() async {
    final response = await Dio().get("https://dog.ceo/api/breeds/image/random");
    final data = response.data as Map<String, dynamic>;
    if (data['status'] == 'success') {
      final String URL = data['message'] as String;
      return URL;
    } else {
      return '';
    }
  }
}
