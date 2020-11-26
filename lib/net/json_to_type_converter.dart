import 'dart:convert';

import 'package:chopper/chopper.dart';

/// JSON Deserialization converter class
class JsonToTypeConverter extends JsonConverter {
  // ignore: public_member_api_docs
  const JsonToTypeConverter(this.typeToJsonFactoryMap);

  /// Map of json deserializers
  final Map<Type, Function> typeToJsonFactoryMap;

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return response.copyWith(
      body: fromJsonData<BodyType, InnerType>(
          response.body as String, typeToJsonFactoryMap[InnerType]),
    );
  }

  // ignore: public_member_api_docs
  T fromJsonData<T, InnerType>(String jsonData, Function jsonParser) {
    final dynamic jsonMap = json.decode(jsonData);

    if (jsonMap is List) {
      return jsonMap
          .map((dynamic item) =>
      jsonParser(item as Map<String, dynamic>) as InnerType)
          .toList() as T;
    }

    return jsonParser(jsonMap) as T;
  }
}
