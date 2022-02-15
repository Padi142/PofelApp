import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp(functions.config().firebase);

export const onNewRegistration = functions.auth.user().onCreate((user) => {
    functions.logger.info("New User Created - Name: ",
        user.email, ", UID: ", user.uid);
    const db = admin.firestore();
    return db.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "name": user.displayName ?? "none",
        "profile_pic": "https://i.ibb.co/qyMYhDQ/opice-hned.png",
        "my_pofels": [],
    });
});
export const onPofelCreated = functions.firestore
    .document("active_pofels/{pofelId}")
    .onCreate(async (snapshot, context) => {
        const pofelId = context.params.pofelId;
        functions.logger.info("New Pofel Created - Id: ",
            pofelId);
        const db = admin.firestore();
        admin.firestore.FieldValue.serverTimestamp();
        const pofel = await snapshot.ref.get();
        const userData = await db.collection("users")
            .doc(pofel.data()!.adminUid).get();
        await snapshot.ref.update({
            "joinId": newGuid(),
        });
        const signedUsers = snapshot.ref.collection("signedUsers")
            .doc(pofel.data()!.adminUid);
        await signedUsers.update({
            "profile_pic": userData!.data()!.profile_pic,
            "name": userData!.data()!.name,
            "willArrive": admin.firestore.Timestamp
                .fromDate(new Date("1989-11-9")),
        });
    });

/**
* Creates uid.
*/
function newGuid() {
    return "xxxxx".replace(/[xy]/g, function(c) {
        const r = Math.random() * 16 | 0;
        const v = c == "x" ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

