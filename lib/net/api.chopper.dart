// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ApiService extends ApiService {
  _$ApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiService;

  @override
  Future<Response<Popular>> getPopularMovies() {
    final $url = 'movie/popular?api_key=46514b47bc995b14fd13c566f27ac058';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Popular, Popular>($request);
  }
}
