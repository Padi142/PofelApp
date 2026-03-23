class AppwriteEnvironment {
  static const endpoint = String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: 'https://fra.cloud.appwrite.io/v1',
  );
  static const projectName = String.fromEnvironment(
    'APPWRITE_PROJECT_NAME',
    defaultValue: 'pofel-app',
  );
  static const projectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
    defaultValue: '69b3250d001749acb479',
  );
  static const databaseId = String.fromEnvironment(
    'APPWRITE_DATABASE_ID',
    defaultValue: 'pofel-db',
  );
  static const bucketId = String.fromEnvironment(
    'APPWRITE_BUCKET_ID',
    defaultValue: 'pofel-bucket',
  );
  static const pushProviderId = String.fromEnvironment(
    'APPWRITE_PUSH_PROVIDER_ID',
    defaultValue: '',
  );

  static const usersCollectionId = String.fromEnvironment(
    'APPWRITE_USERS_COLLECTION_ID',
    defaultValue: 'users',
  );
  static const followsCollectionId = String.fromEnvironment(
    'APPWRITE_FOLLOWS_COLLECTION_ID',
    defaultValue: 'user_follows',
  );
  static const notificationsCollectionId = String.fromEnvironment(
    'APPWRITE_NOTIFICATIONS_COLLECTION_ID',
    defaultValue: 'user_notifications',
  );
  static const activePofelsCollectionId = String.fromEnvironment(
    'APPWRITE_ACTIVE_POFELS_COLLECTION_ID',
    defaultValue: 'active_pofels',
  );
  static const signedUsersCollectionId = String.fromEnvironment(
    'APPWRITE_SIGNED_USERS_COLLECTION_ID',
    defaultValue: 'pofel_signed_users',
  );
  static const pofelItemsCollectionId = String.fromEnvironment(
    'APPWRITE_POFEL_ITEMS_COLLECTION_ID',
    defaultValue: 'pofel_items',
  );
  static const pofelTodosCollectionId = String.fromEnvironment(
    'APPWRITE_POFEL_TODOS_COLLECTION_ID',
    defaultValue: 'pofel_todos',
  );
  static const pofelMessagesCollectionId = String.fromEnvironment(
    'APPWRITE_POFEL_MESSAGES_COLLECTION_ID',
    defaultValue: 'pofel_messages',
  );
  static const pofelPhotosCollectionId = String.fromEnvironment(
    'APPWRITE_POFEL_PHOTOS_COLLECTION_ID',
    defaultValue: 'pofel_photos',
  );
  static const kyblspotsCollectionId = String.fromEnvironment(
    'APPWRITE_KYBLSPOTS_COLLECTION_ID',
    defaultValue: 'kyblspots',
  );
  static const kyblspotReviewsCollectionId = String.fromEnvironment(
    'APPWRITE_KYBLSPOT_REVIEWS_COLLECTION_ID',
    defaultValue: 'kyblspot_reviews',
  );

  static bool get hasProjectConfig => projectId.isNotEmpty;

  static bool get hasDatabaseConfig =>
      hasProjectConfig && databaseId.isNotEmpty;

  static bool get hasStorageConfig => hasProjectConfig && bucketId.isNotEmpty;
}
