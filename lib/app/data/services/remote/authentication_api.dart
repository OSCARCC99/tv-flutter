import '../../../domain/either/either.dart';
import '../../../domain/failures/sign_in/sign_in_failure.dart';
import '../../http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http);

  final Http _http;

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      print('AAAAAAAAAAAAA failure.statusCode ${failure.statusCode}');
      switch (failure.statusCode!) {
        case 401:
          if (failure.data is Map && (failure.data as Map)['status_code']==32) {
            return Either.left(
              SignInFailure.notVerified(),
            );
          }

          return Either.left(
            SignInFailure.unauthorized(),
          );

        case 404:
          return Either.left(
            SignInFailure.notFound(),
          );

        default:
          return Either.left(
            SignInFailure.unknown(),
          );
      }
    }

    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.network());
    }

    return Either.left(SignInFailure.unknown());
  }

  final _base_Url = 'https://api.themoviedb.org/3';
  final _apiKey = '30fc232d02a240bbdd38d18fb1685c37';

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['request_token'] as String;
      },
    );

    return result.when(
      left: _handleFailure,
      right: (requestToken) => Either.right(
        requestToken,
      ),
    );
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
      onSuccess: (responseBody) {
        final json = responseBody as Map;

        return json['request_token'] as String;
      },
    );
    return result.when(
      left: _handleFailure,
      right: (newRequestToken) => Either.right(
        newRequestToken,
      ),
    );
  }

  Future<Either<SignInFailure, String>> createSession(
    String requestToken,
  ) async {
    final result = await _http.request(
      '/authentication/session/new',
      method: HttpMethod.post,
      body: {
        'request_token': requestToken,
      },
      onSuccess: (responseBody) {
        final json = responseBody;

        return json['session_id'] as String;
      },
    );
//video 290
    return result.when(
      left: _handleFailure,
      right: (sessionId) => Either.right(sessionId),
    );
  }
}
