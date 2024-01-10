import 'dart:convert';
import 'package:climatempo/model/cidade.dart';
import 'package:climatempo/model/clima_tempo.dart';
import 'package:http/http.dart' as http;

const apiBaseUrl = 'https://apiadvisor.climatempo.com.br';
const token = '5c305e6eacd864bf0273fb95344198db';

Future<List<Cidade>> buscarCidades({String? nome, String? estado}) async {
  var url = '$apiBaseUrl/api/v1/locale/city?';
  if (nome != null) url += 'name=$nome';
  if (estado != null) url += '&state=$estado';

  final response = await http.get(Uri.parse('$url&token=$token'));

  if (response.statusCode != 200) throw response.body;

  final responseJson = json.decode(response.body);
  final cidades = <Cidade>[];
  responseJson.forEach((map) => cidades.add(Cidade.fromJson(map)));

  return cidades;
}

Future<void> registrarCidade({required int idCidade}) async {
  final url = '$apiBaseUrl/api-manager/user-token/$token/locales';
  final map = {'localeId[]': '$idCidade'};

  await http.put(Uri.parse(url), body: map);
}

Future<ClimaTempo> climaAtual({required int idCidade}) async {
  final url =
      '$apiBaseUrl/api/v1/weather/locale/$idCidade/current?token=$token';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) throw response.body;

  final responseJson = json.decode(response.body);

  return ClimaTempo.fromJson(responseJson);
}
