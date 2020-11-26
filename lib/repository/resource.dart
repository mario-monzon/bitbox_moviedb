import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../net/status_codes.dart';

/// The current status of a resource
enum Status {
  /// The resource is empty and it not working
  none,

  /// The resource is working to load data
  working,

  /// The resource data has been loaded
  loaded,

  /// There was an error loading the resource
  error,

  /// There loading of the resource has been cancelled
  cancelled,
}

/// This class is used to handle the loading of a resource.
/// This resource can be any model and will be stored in the 'data' field
/// In status you can check the current loading status
class Resource<T> extends ChangeNotifier {
  // ignore: public_member_api_docs
  Resource({T data, Status status, String error, int httpStatusCode})
      : _data = data,
        _status = status,
        _error = error,
        _httpStatusCode = httpStatusCode;

  T _data;

  /// The data of this resource. Of type T
  T get data => _data;

  set data(T value) {
    _data = value;
    _status = Status.loaded;
    notifyListeners();
  }

  Status _status = Status.none;

  /// The current loading status of this resource
  Status get status => _status;

  set status(Status value) {
    _status = value;
    notifyListeners();
  }

  String _error;

  /// If there was an error loading the resource,
  /// this field should hold an error message
  String get error => _error;

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  int _httpStatusCode;

  /// HTTP response status code,
  /// only used for resources loaded from network through http
  int get httpStatusCode => _httpStatusCode;

  set httpStatusCode(int value) {
    _httpStatusCode = value;
    notifyListeners();
  }

  /// Changes properties and notifies listeners.
  /// Use this function when you want to set more than one property,
  /// to avoid consecutive calls to notifyListeners()
  void change({T data, Status status, String error, int httpStatusCode}) {
    if (data != null) _data = data;
    if (status != null) _status = status;
    if (error != null) _error = error;
    if (httpStatusCode != null) _httpStatusCode = httpStatusCode;

    notifyListeners();
  }

  /// Copies from another resource of the same type, giving the opportunity to
  /// change some of its fields
  void copy(Resource<T> copy,
      {T data, Status status, String error, int httpStatusCode}) {
    change(
        data: data ?? copy.data,
        status: status ?? copy.status,
        error: error ?? copy.error,
        httpStatusCode: httpStatusCode ?? copy.httpStatusCode);
  }

  /// Copies all except data from another resource of any
  /// type, giving the opportunity to change some of its fields
  void copyWithNewData(Resource copy, T data,
      {Status status, String error, int httpStatusCode}) {
    change(
        data: data,
        status: status ?? copy.status,
        error: error ?? copy.error,
        httpStatusCode: httpStatusCode ?? copy.httpStatusCode);
  }

  /// Resets this resource.
  /// Data will be empty and the loading status will be 'none'
  void reset() {
    _data = null;
    _status = Status.none;
    _error = null;
    _httpStatusCode = null;

    notifyListeners();
  }

  /// A method that returns a generic network error for the
  /// httpStatusCode of this resource
  // String networkError(BuildContext context) {
  //   String err;
  //   switch (_httpStatusCode) {
  //     case StatusCodes.unauthorized:
  //     case StatusCodes.forbidden:
  //       err = S.of(context).errorNetworkUnauthorized;
  //       break;
  //     case StatusCodes.internalServerError:
  //     case StatusCodes.serviceUnavailable:
  //       err = S.of(context).errorNetworkServer;
  //       break;
  //     default:
  //       err = S.of(context).errorNetworkGeneric;
  //       break;
  //   }
  //
  //   return err;
  // }
}
