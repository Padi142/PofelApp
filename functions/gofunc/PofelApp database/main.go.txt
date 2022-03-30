package main

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/option"
)

func main() {
	var ctx = context.Background()

	sa := option.WithCredentialsFile("./serviceAccountKey.json")
	app, err := firebase.NewApp(ctx, &firebase.Config{ProjectID: "pofelapp-420"}, sa)
	if err != nil {
		log.Fatal(err)
	}
	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatal(err)
	}
	defer client.Close()

	q := client.Collection("users")
	users, _ := q.Documents(ctx).GetAll()
	fmt.Println(len(users))
	index := 0

	for _, user := range users {
		followers, err := user.Ref.Collection("followers").Documents(ctx).GetAll()
		if err == nil {
			for _, follower := range followers {
				_, error := follower.DataAt("name")
				if error != nil {
					index++

					uid, err := follower.DataAt("uid")
					if err != nil {
						log.Fatal(err)
					}
					user, err := client.Collection("users").Doc(uid.(string)).Get(ctx)
					if err != nil {
						log.Fatal(err)
					}
					name, err := user.DataAt("name")
					profile_pic, err := user.DataAt("profile_pic")
					follower.Ref.Update(ctx, []firestore.Update{
						{
							Path:  "isPremium",
							Value: false,
						},
						{
							Path:  "name",
							Value: name,
						},
						{
							Path:  "profile_pic",
							Value: profile_pic,
						},
					},
					)
					fmt.Println(index)
					fmt.Println(name)
				}
			}
		}
		following, err := user.Ref.Collection("following").Documents(ctx).GetAll()
		if err == nil {
			index := 0
			for _, follower := range following {
				_, error := follower.DataAt("name")
				if error != nil {
					index++
					uid, err := follower.DataAt("uid")
					if err != nil {
						log.Fatal(err)
					}
					user, err := client.Collection("users").Doc(uid.(string)).Get(ctx)
					if err != nil {
						log.Fatal(err)
					}
					name, err := user.DataAt("name")
					profile_pic, err := user.DataAt("profile_pic")
					follower.Ref.Update(ctx, []firestore.Update{
						{
							Path:  "isPremium",
							Value: false,
						},
						{
							Path:  "name",
							Value: name,
						},
						{
							Path:  "profile_pic",
							Value: profile_pic,
						},
					},
					)
					fmt.Println(index)
					fmt.Println(name)
				}
			}
		}
	}
}
