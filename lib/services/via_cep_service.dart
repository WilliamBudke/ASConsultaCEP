
import 'package:http/http.dart' as http;
import 'package:web_service/models/result_cep.dart';

class ViaCepService {
  static Future<ResultCep> fetchCep({String? cep})
  async {
    ResultCep aux;
    final Uri uri = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.body);
    } else if(response.statusCode == 404) {
      return aux='Cep não encontrado' as ResultCep;
    }else{
      throw Exception('Requisição inválida!');
    }
  }
}