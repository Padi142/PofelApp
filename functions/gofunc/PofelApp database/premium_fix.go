// Package p contains a Firestore Cloud Function.
package p

import (
	"context"
	"log"
	"math/rand"
	"strings"
	"time"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
)

// FirestoreEvent is the payload of a Firestore event.
type FirestoreEvent struct {
	OldValue   FirestoreValue `json:"oldValue"`
	Value      FirestoreValue `json:"value"`
	UpdateMask struct {
		FieldPaths []string `json:"fieldPaths"`
	} `json:"updateMask"`
}

// FirestoreValue holds Firestore fields.
type FirestoreValue struct {
	CreateTime time.Time `json:"createTime"`
	// Fields is the data for this value. The type depends on the format of your
	// database. Log an interface{} value and inspect the result to see a JSON
	// representation of your database fields.
	Name       string    `json:"name"`
	UpdateTime time.Time `json:"updateTime"`
}

// HelloFirestore is triggered by a change to a Firestore document.
func OnPofelCreated(ctx context.Context, e FirestoreEvent) error {
	var context = context.Background()
	rand.Seed(time.Now().UnixNano())
	var client *firestore.Client

	app, err := firebase.NewApp(context, &firebase.Config{ProjectID: "pofelapp-420"})
	if err != nil {
		log.Fatal(err)
	}

	client, err = app.Firestore(context)
	messagingClient, err := app.Messaging(ctx)

	if err != nil {
		log.Fatal(err)
	}
	defer client.Close()

	fullPath := strings.Split(e.Value.Name, "/active_pofels/")[1]
	pathParts := strings.Split(fullPath, "/")
	pofelId := pathParts[0]
	userId := pathParts[2]
	log.Printf("Someone joined pofel. Pofel Id: %v", pofelId)

	pofel, err := client.Collection("active_pofels").Doc(pofelId).Get(context)
	user, err := client.Collection("users").Doc(userId).Get(context)
	if err != nil {
		log.Fatal(err)
	}

	pofelName, _ := pofel.DataAt("name")
	userName, _ := user.DataAt("name")

	message := &messaging.Message{
		Data: map[string]string{
			"title": "Někdo se právě připojil k pofelu!",
			"body":  "K pofelu " + pofelName.(string) + " se právě připojil uživatel " + userName.(string),
		},
		Topic: pofelId,
	}
	messagingClient.Send(ctx, message)

	return nil
}
