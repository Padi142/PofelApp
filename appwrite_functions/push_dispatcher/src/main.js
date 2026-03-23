import { Client, ID, Messaging } from 'node-appwrite';

const DEFAULT_TITLE = 'Pofel';

function notificationTitle(type) {
  switch ((type ?? '').toUpperCase()) {
    case 'INVITE':
      return 'Nová pozvánka';
    case 'FOLLOW':
      return 'Nový follow';
    case 'MESSAGE':
      return 'Nová zpráva v chatu';
    case 'ANNOUNCEMENT':
      return 'Důležité oznámení';
    case 'QUEST_ASSIGNED':
      return 'Nový quest';
    case 'QUEST_COMPLETED':
      return 'Quest dokončen';
    default:
      return DEFAULT_TITLE;
  }
}

function notificationAction(payload) {
  const pofelId = (payload?.pofelId ?? '').toString().trim();
  if (!pofelId) {
    return 'pofel://notifications';
  }

  return `pofel://pofel/${pofelId}`;
}

function isNotificationCreateEvent(eventHeader) {
  return eventHeader.includes('tables.user_notifications.rows') &&
      eventHeader.endsWith('.create');
}

export default async function ({ req, res, log, error }) {
  const eventName = (req.headers['x-appwrite-event'] ?? '').toString();
  if (!isNotificationCreateEvent(eventName)) {
    return res.json({
      ok: true,
      skipped: true,
      reason: 'unsupported_event',
      eventName,
    });
  }

  const payload = req.bodyJson ?? {};
  const recipientUserId = (payload.recipientUserId ?? '').toString().trim();
  const body = (payload.message ?? '').toString().trim();

  if (!recipientUserId || !body) {
    return res.json({
      ok: true,
      skipped: true,
      reason: 'missing_payload_fields',
    });
  }

  try {
    const endpoint = process.env.APPWRITE_FUNCTION_API_ENDPOINT;
    const projectId = process.env.APPWRITE_FUNCTION_PROJECT_ID;
    const apiKey =
        req.headers['x-appwrite-key'] ?? process.env.APPWRITE_FUNCTION_API_KEY;

    if (!endpoint || !projectId || !apiKey) {
      throw new Error('Missing Appwrite function environment configuration.');
    }

    const client = new Client()
      .setEndpoint(endpoint)
      .setProject(projectId)
      .setKey(apiKey);

    const messaging = new Messaging(client);

    const result = await messaging.createPush({
      messageId: ID.unique(),
      title: notificationTitle(payload.type),
      body,
      users: [recipientUserId],
      data: {
        notificationId: (payload.id ?? '').toString(),
        notificationType: (payload.type ?? 'NONE').toString(),
        pofelId: (payload.pofelId ?? '').toString(),
        actorUserId: (payload.userId ?? '').toString(),
      },
      action: notificationAction(payload),
      draft: false,
    });

    log(`Push message queued: ${result.$id}`);
    return res.json({
      ok: true,
      messageId: result.$id,
    });
  } catch (err) {
    error(`Push dispatch failed: ${err?.message ?? err}`);
    return res.json(
      {
        ok: false,
        error: err?.message ?? 'Unknown push dispatch failure.',
      },
      500,
    );
  }
}
