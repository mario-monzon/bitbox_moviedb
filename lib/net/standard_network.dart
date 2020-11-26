import 'dart:async';
import 'dart:math';

import 'package:chopper/chopper.dart';

import '../repository/resource.dart';

/// Class to be used for standard calls to the API
/// It will try to load a Resource<T> fof the specified type for a specific
/// API method.
/// If the http status code is an error code, it will set the
/// resource status to error

class StandardApiCall<T> {
  // ignore: public_member_api_docs
  StandardApiCall(
      this.apiMethod,
      this.resource, {
        this.customCallback,
        this.resetDataOnCall = true,
        this.retryForever = false,
      });

  /// The chopper api method
  Future<Response<T>> Function() apiMethod;

  /// The Resource to be loaded
  Resource<T> resource;

  /// A special custom callback that will override the normal behaviour
  /// provided by standardCallback
  Function(Response<T>, Resource<T> resource) customCallback;

  /// Indicates it the resource should be cleared of data before doing the api
  /// call. Defaults to true
  bool resetDataOnCall;

  /// If set to true this call will be retried on error forever
  /// The retries will have an exponential falloff
  bool retryForever;
  static const int _initialInterval = 500;
  static const double _intervalMultiplier = 1.5;
  static const double _intervalRandomizationFactor = 0.5;
  static const int _maxInterval = 60000;
  var _nextInterval = _initialInterval;

  bool _cancelled = false;

  // ignore: public_member_api_docs
  Response response;

  /// If you need to do something different that the standard
  /// callback handler does, use the customCallback parameter
  void call() {
    if (resetDataOnCall) {
      resource.reset();
      resource.status = Status.working;
    } else {
      resource.change(
          status: Status.working, error: null, httpStatusCode: null);
    }

    void Function(Response<T> r) responseHandler;
    void Function(dynamic e) errorHandler;

    final void Function() retry = () async {
      await Future.delayed(Duration(milliseconds: _nextInterval));
      _calculateNextInterval();
      apiMethod().then(responseHandler).catchError(errorHandler);
    };

    responseHandler = (r) async {
      response = r;

      if (!_cancelled) {
        if (retryForever && (!response.isSuccessful)) {
          retry();
          return;
        }

        if (customCallback != null) {
          customCallback(r, resource);
        } else {
          standardCallback(r, resource);
        }
      }
    };

    errorHandler = (e) {
      if (!_cancelled) {
        if (retryForever) {
          retry();
          return;
        }

        Response<T> response;
        if (e is Response<T>) {
          response = e;
        } else if (e is Exception) {
          // we can catch especific exceptions to show a especific
          // message here if needed some time in the future
        }

        if (customCallback != null) {
          customCallback(response, resource);
        } else {
          standardCallback(response, resource);
        }
      }
    };
    apiMethod().then(responseHandler).catchError(errorHandler);
  }

  /// cancels the request, ignoring its results
  /// warning: an ongoing request may still do whatever it does in the server
  void cancel() {
    _cancelled = true;
    response = null;
    resource.change(data: null, status: Status.cancelled, error: null);
  }

  // ignore: public_member_api_docs
  void standardCallback(Response<T> response, Resource<T> resource) {
    if (response == null) {
      resource.change(
          data: null, status: Status.error, error: null, httpStatusCode: null);
    } else if (response.isSuccessful) {
      resource.change(
          data: response.body,
          status: Status.loaded,
          error: null,
          httpStatusCode: response.statusCode);
    } else {
      resource.change(
          data: null,
          status: Status.error,
          error: response.bodyString,
          httpStatusCode: response.statusCode);
    }
  }

  void _calculateNextInterval() {
    final r = Random.secure();
    _nextInterval = (_nextInterval *
        (_intervalMultiplier +
            (r.nextDouble() * _intervalRandomizationFactor)))
        .toInt();
    if (_nextInterval > _maxInterval) _nextInterval = _maxInterval;
  }
}
