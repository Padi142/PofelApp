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

export const onUserJoined = functions.firestore
    .document("active_pofels/{pofelId}/signedUsers/{userId}")
    .onCreate(async (snapshot, context) => {
        const pofelId = context.params.pofelId;
        functions.logger.info("User joined to: ",
            pofelId);
        const db = admin.firestore();
        const user = await snapshot.ref.get();
        const topic = pofelId;
        const pofel = await db.collection("active_pofels")
            .doc(pofelId).get();
        // Notification details and Payload.
        const payload = {
            notification: {
                title: "Někdo se právě připojit k pofelu!",
                body: "K pofelu " + pofel.data()!.name +
                    " se právě připojil uživatel " + user.data()!.name,
            },
        };
        return admin.messaging().sendToTopic(topic, payload);
    });

export const onItemAdded = functions.firestore
    .document("active_pofels/{pofelId}/items/{itemId}")
    .onCreate(async (snapshot, context) => {
        const pofelId = context.params.pofelId;
        functions.logger.info("New Item Added - PofelId: ",
            pofelId);
        const db = admin.firestore();
        const pofel = await snapshot.ref.get();
        const userData = await db.collection("users")
            .doc(pofel.data()!.addedByUid).get();
        await snapshot.ref.update({
            "addedByProfilePic": userData!.data()!.profile_pic,
            "addedBy": userData!.data()!.name,
        });
    });
export const onTodoAssigned = functions.firestore
    .document("active_pofels/{pofelId}/todo/{todoId}")
    .onCreate(async (snapshot, context) => {
        const pofelId = context.params.pofelId;
        functions.logger.info("New Todo Assigned - PofelId: ",
            pofelId);
        const db = admin.firestore();
        const todo = await snapshot.ref.get();
        const userData = await db.collection("users")
            .doc(todo.data()!.assignedByUid).get();
        await snapshot.ref.update({
            "assignedByProfilePic": userData!.data()!.profile_pic,
            "assignedByName": userData!.data()!.name,
        });
        const topic = todo.data()!.assignedToUid;
        const payload = {
            notification: {
                title: "Někdo ti právě přiřadil quest!",
                body: userData.data()!.name + " ti právě dal quest: " +
                    todo.data()!.todoTitle,
            },
        };
        return admin.messaging().sendToTopic(topic, payload);
    });

export const notifyPofelUsers = functions.https.onCall(async (data, _) => {
    try {
        const topic = data.pofelId;
        await admin.messaging().sendToTopic(topic, {
            notification: {
                title: data.messageTitle,
                body: data.messageBody,
            },
        });
        functions.logger.info("Notified users: ",
            data.pofelId);
        return true;
    } catch (ex) {
        return false;
    }
});
export const onUserSettingsChanged = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
        const userId = context.params.userId;
        const newUsername = change.after.data().name;
        const previousUsername = change.before.data().name;

        const newProfilePic = change.after.data().profile_pic;
        const previousProfilePic = change.before.data().profile_pic;

        if (newUsername.localeCompare(previousUsername) !== 0) {
            functions.logger.info("User name changed, updating pofels" +
                ". User id: ",
                userId);
            const db = admin.firestore();

            const pofelsRef = db.collection("active_pofels")
            .where("signedUsers", "array-contains", userId);

            return pofelsRef.get()
                .then((querySnapshot) => {
                    if (querySnapshot.empty) {
                        return null;
                    } else {
                        const promises: any[] = [];
                        querySnapshot.forEach((doc) => {
                            promises.push(doc.ref.collection("signedUsers")
                            .doc(userId).update({
                                "name": newUsername,
                            }));
                            doc.ref.collection("items")
                            .where("addedByUid", "==", userId)
                            .get().then((itemSnapshot) => {
                                itemSnapshot.forEach((item) => {
                                    promises.push(doc.ref.update({
                                        "addedBy": newUsername,
                                    }));
                                });
                            });

                            doc.ref.collection("todo")
                            .where("assignedToUid", "==", userId)
                            .get().then((todoSnapshot) => {
                                todoSnapshot.forEach((todo) => {
                                    promises.push(doc.ref.update({
                                        "assignedToName": newUsername,
                                    }));
                                });
                            });
                        });

                        return Promise.all(promises);
                    }
                });
        } else if (newProfilePic.localeCompare(previousProfilePic) !== 0) {
            functions.logger.info("Profile pic changed, updating pofels" +
            ". User id: ",
            userId);
        const db = admin.firestore();

        const pofelsRef = db.collection("active_pofels")
        .where("signedUsers", "array-contains", userId);

        return pofelsRef.get()
            .then((querySnapshot) => {
                if (querySnapshot.empty) {
                    return null;
                } else {
                    const promises: any[] = [];
                    querySnapshot.forEach((doc) => {
                        promises.push(doc.ref.collection("signedUsers")
                        .doc(userId).update({
                            "profile_pic": newProfilePic,
                        }));
                        doc.ref.collection("items")
                        .where("addedByUid", "==", userId)
                        .get().then((itemSnapshot) => {
                            itemSnapshot.forEach((item) => {
                                promises.push(doc.ref.update({
                                    "addedByProfilePic": newProfilePic,
                                }));
                            });
                        });

                        doc.ref.collection("todo")
                        .where("assignedToUid", "==", userId)
                        .get().then((todoSnapshot) => {
                            todoSnapshot.forEach((todo) => {
                                promises.push(doc.ref.update({
                                    "assignedToProfilePic": newProfilePic,
                                }));
                            });
                        });
                    });

                    return Promise.all(promises);
                }
            });
        } else {
            return null;
        }
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

