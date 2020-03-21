package main

import (
	"context"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var ctx context.Context
var wordsCollection *mongo.Collection
var accountsCollection *mongo.Collection

func handleMongodb() {
	ctx, cancelFunc := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancelFunc()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://root:ewqewq@mongodb:27017"))
	if err != nil {
		log.Fatal(err)
	}
	err = client.Ping(context.TODO(), nil)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Connected to MongoDB!")
	wordsCollection = client.Database("testing").Collection("words")
	accountsCollection = client.Database("testing").Collection("accounts")
}
