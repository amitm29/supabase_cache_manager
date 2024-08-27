# flutter_cache_manager_supabase

A Supabase implementation for [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)

## Getting Started

This library contains SupabaseCacheManager and SupabaseHttpFileService.

You can easily fetch a file stored on Supabase storage with
```dart
var file = await SupabaseCacheManager('your-bucket-id').getSingleFile(filePath);
```

You could also write your own CacheManager which uses the SupabaseHttpFileService.
