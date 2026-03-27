import { Client, Databases, Query } from 'node-appwrite';

const DATABASE_ID = process.env.APPWRITE_DATABASE_ID ?? 'pofel-db';
const ACTIVE_POFELS_COLLECTION_ID =
    process.env.APPWRITE_ACTIVE_POFELS_COLLECTION_ID ?? 'active_pofels';

function getInviteCode(req) {
  let body = {};
  try {
    body = req.bodyJson ?? {};
  } catch (_) {
    body = {};
  }

  return (
    body.inviteCode ??
    body.joinId ??
    req.query?.inviteCode ??
    req.query?.joinId ??
    ''
  ).toString().trim();
}

function getApiKey(req) {
  return (
    req.headers['x-appwrite-key'] ??
    process.env.APPWRITE_FUNCTION_API_KEY ??
    ''
  ).toString().trim();
}

function participantCount(pofel) {
  if (Array.isArray(pofel?.signedUsers)) {
    return pofel.signedUsers.length;
  }

  return 0;
}

export default async function ({ req, res, error }) {
  const inviteCode = getInviteCode(req);
  if (!inviteCode) {
    return res.json(
      {
        ok: false,
        error: 'Missing inviteCode.',
      },
      400,
    );
  }

  try {
    const endpoint = process.env.APPWRITE_FUNCTION_API_ENDPOINT;
    const projectId = process.env.APPWRITE_FUNCTION_PROJECT_ID;
    const apiKey = getApiKey(req);

    if (!endpoint || !projectId || !apiKey) {
      throw new Error('Missing Appwrite function environment configuration.');
    }

    const client = new Client()
      .setEndpoint(endpoint)
      .setProject(projectId)
      .setKey(apiKey);

    const databases = new Databases(client);
    const response = await databases.listDocuments(
      DATABASE_ID,
      ACTIVE_POFELS_COLLECTION_ID,
      [
        Query.equal('joinId', inviteCode),
        Query.limit(1),
      ],
    );

    const document = response.documents[0];
    if (!document) {
      return res.json(
        {
          ok: false,
          error: 'Pofel not found.',
        },
        404,
      );
    }

    return res.json({
      ok: true,
      pofel: {
        id: document.$id,
        pofelId: document.pofelId ?? document.$id,
        inviteCode: document.joinId ?? inviteCode,
        name: document.name ?? '',
        description: document.description ?? '',
        participantCount: participantCount(document),
        dateFrom: document.dateFrom ?? null,
        dateTo: document.dateTo ?? null,
        isPublic: Boolean(document.isPublic),
      },
    });
  } catch (err) {
    error(`Invite lookup failed: ${err?.message ?? err}`);
    return res.json(
      {
        ok: false,
        error: err?.message ?? 'Unknown invite lookup failure.',
      },
      500,
    );
  }
}
