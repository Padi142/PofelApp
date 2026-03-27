class PofelDeepLinkParser {
  static String? parseJoinId(Uri? uri) {
    if (uri == null) {
      return null;
    }

    final inviteQuery = uri.queryParameters['invite']?.trim();
    if (inviteQuery != null && inviteQuery.isNotEmpty) {
      return inviteQuery;
    }

    if (uri.scheme == 'pofel' &&
        uri.host == 'join' &&
        uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first.trim();
    }

    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments.first == 'join') {
      return uri.pathSegments[1].trim();
    }

    return null;
  }
}
