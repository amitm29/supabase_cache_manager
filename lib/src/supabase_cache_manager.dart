import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:retry/retry.dart';

import 'supabase_http_file_service.dart';

/// Use [SupabaseCacheManager] if you want to download files from supabase storage
/// and store them in your local cache.
class SupabaseCacheManager extends CacheManager {
  static const key = 'supabaseCache';

  static final SupabaseCacheManager _instance = SupabaseCacheManager._(
    bucketId: bucketId,
    retryOptions: retryOptions,
  );

  static RetryOptions? retryOptions;
  static String bucketId = '';

  factory SupabaseCacheManager({
    required String bucketId,
    RetryOptions? retryOptions,
  }) {
    SupabaseCacheManager.retryOptions = retryOptions;
    SupabaseCacheManager.bucketId = bucketId;
    return _instance;
  }

  SupabaseCacheManager._({
    required String bucketId,
    RetryOptions? retryOptions,
  }) : super(
          Config(
            key,
            fileService: SupabaseHttpFileService(
              retryOptions: retryOptions,
              bucketId: bucketId,
            ),
          ),
        );
}
