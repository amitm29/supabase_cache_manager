import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:retry/retry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [SupabaseHttpFileService] is another common file service which parses a
/// supabase filePath into, to standard url which can be passed to the
/// standard [HttpFileService].
class SupabaseHttpFileService extends HttpFileService {
  final RetryOptions? retryOptions;
  final String bucketId;

  SupabaseHttpFileService({
    required this.bucketId,
    this.retryOptions,
  }) : super();

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    // remove bucketId prefix from the filePath
    final filePath = url.replaceFirst('$bucketId/', '');
    debugPrint('filePath: $filePath');
    String downloadUrl;
    if (retryOptions != null) {
      downloadUrl = await retryOptions!.retry(
        () async => await _createSignedUrl(filePath),
        retryIf: (e) => e is StorageException,
      );
    } else {
      downloadUrl = await _createSignedUrl(filePath);
    }
    debugPrint('download URL: $downloadUrl');
    return super.get(downloadUrl);
  }

  Future<String> _createSignedUrl(String filePath) =>
      Supabase.instance.client.storage.from(bucketId).createSignedUrl(
            filePath,
            5 * 60,
          );
}
