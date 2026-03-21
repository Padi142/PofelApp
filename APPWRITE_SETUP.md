# Appwrite Setup

Run the app with Dart defines:

```bash
flutter run \
  --dart-define=APPWRITE_ENDPOINT=https://fra.cloud.appwrite.io/v1 \
  --dart-define=APPWRITE_PROJECT_ID=69b3250d001749acb479 \
  --dart-define=APPWRITE_PROJECT_NAME=pofel-app \
  --dart-define=APPWRITE_DATABASE_ID=pofel-db \
  --dart-define=APPWRITE_BUCKET_ID=pofel-bucket
```

`APPWRITE_ENDPOINT`, `APPWRITE_PROJECT_ID`, `APPWRITE_PROJECT_NAME`, `APPWRITE_DATABASE_ID`, and `APPWRITE_BUCKET_ID` now have these values as in-app defaults, so you only need overrides when pointing the app at a different Appwrite project.

Optional collection overrides are available through:

- `APPWRITE_USERS_COLLECTION_ID`
- `APPWRITE_FOLLOWS_COLLECTION_ID`
- `APPWRITE_NOTIFICATIONS_COLLECTION_ID`
- `APPWRITE_ACTIVE_POFELS_COLLECTION_ID`
- `APPWRITE_SIGNED_USERS_COLLECTION_ID`
- `APPWRITE_POFEL_ITEMS_COLLECTION_ID`
- `APPWRITE_POFEL_TODOS_COLLECTION_ID`
- `APPWRITE_POFEL_MESSAGES_COLLECTION_ID`
- `APPWRITE_POFEL_PHOTOS_COLLECTION_ID`
- `APPWRITE_KYBLSPOTS_COLLECTION_ID`
- `APPWRITE_KYBLSPOT_REVIEWS_COLLECTION_ID`

These values must be the real Appwrite collection IDs inside your database, not just display names. If your Appwrite console created IDs like `67f...` instead of `users`, you must pass those exact IDs with `--dart-define`.

Expected flat Appwrite collections:

- `users`
- `user_follows`
- `user_notifications`
- `active_pofels`
- `pofel_signed_users`
- `pofel_items`
- `pofel_todos`
- `pofel_messages`
- `pofel_photos`
- `kyblspots`
- `kyblspot_reviews`

If you see an error like `collection_not_found` for `users`, it means either:

- the collection with ID `users` does not exist in the database referenced by `APPWRITE_DATABASE_ID`
- or your real collection ID is different and you need to pass `APPWRITE_USERS_COLLECTION_ID=...`

Key schema notes:

- Dates are stored as ISO 8601 strings.
- `pofelLocation` and `location` are stored in Appwrite as JSON strings like `{ "lat": double, "lng": double }`, and the app deserializes them automatically.
- `active_pofels.signedUsers` remains a string array for quick membership checks.
- `pofel_signed_users`, `pofel_items`, `pofel_todos`, `pofel_messages`, and `pofel_photos` all carry a `pofelId` field instead of nested subcollections.
- `user_notifications` carries `recipientUserId`.

The login flow now creates an anonymous Appwrite session and a default user profile document on first launch.
