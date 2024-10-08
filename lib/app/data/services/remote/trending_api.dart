import '../../../domain/either/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/failures/http_request/http_request_failure.dart';
import '../../../domain/models/media/media.dart';
import '../../http/http.dart';
import '../utils/handle_failure.dart';

class TrendingAPI {
  final Http _http;

  TrendingAPI(this._http);

  Future<Either<HttpRequestFailure, List<Media>>> getMoviesAndSeries(
      TimeWindow timeWindow) async {
    final result = await _http.request(
      '/trending/all/${timeWindow.name}',
      onSuccess: (json) {
        final list = List.from(json['results']);
        return list
            .where(
              (e) => e['media_type'] != 'person' && e ['title'] !=null,
            )
            .map(
              (e) => Media.fromJson(e),
            )
            .toList();
      },
    );
    return result.when(
      left:handleHttpFailure,
      right: (list) => Either.right(list),
    );
  }
}
