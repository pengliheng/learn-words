package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Account is a account type
type Account struct {
	Name     string
	Password string
}

// Word is a word title
type Word struct {
	ID       primitive.ObjectID
	Name     string
	Author   string
	CreateAt time.Time
	UpdateAt time.Time
}

const cookieTokenName = "Admin-Token"

// 获取所有书
func getWords(w http.ResponseWriter, r *http.Request) {
	ctx, cancelFunc := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancelFunc()
	cur, _ := wordsCollection.Find(ctx, bson.D{})
	res := []bson.M{}
	for cur.Next(ctx) {
		var result bson.M
		err := cur.Decode(&result)
		if err != nil {
			log.Fatal(err)
		}
		res = append(res, result)
	}
	json.NewEncoder(w).Encode(
		bson.M{
			"errorCode": 0,
			"data":      res,
		},
	)
}

// 创建书
func createWord(w http.ResponseWriter, r *http.Request) {
	var word Word
	json.NewDecoder(r.Body).Decode(&word)
	result, err := wordsCollection.InsertOne(
		context.Background(),
		bson.D{
			primitive.E{Key: "name", Value: word.Name},
			primitive.E{Key: "author", Value: word.Author},
			primitive.E{Key: "createAt", Value: time.Now()},
			primitive.E{Key: "updateAt", Value: time.Now()},
		},
	)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(
		bson.M{
			"errorCode": 0,
			"data":      result,
		},
	)
}

// 更新书
func updateWord(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r) // get params
	var word Word
	json.NewDecoder(r.Body).Decode(&word)
	objectID, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		log.Fatal(err)
	}
	result, err := wordsCollection.UpdateOne(
		context.Background(),
		bson.D{
			primitive.E{Key: "_id", Value: objectID},
		},
		bson.D{
			primitive.E{Key: "$set", Value: bson.D{
				primitive.E{Key: "name", Value: word.Name},
				primitive.E{Key: "author", Value: word.Author},
				primitive.E{Key: "updateAt", Value: time.Now()},
			}},
		},
	)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(
		bson.M{
			"errorCode": 0,
			"data":      result,
		},
	)
}

func deleteWord(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r) // get params
	objectID, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		log.Fatal(err)
	}
	result, err := wordsCollection.DeleteOne(
		context.Background(),
		bson.D{
			primitive.E{Key: "_id", Value: objectID},
		},
	)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(
		bson.M{
			"errorCode": 0,
			"data":      result,
		},
	)
}

func handleLogin(w http.ResponseWriter, r *http.Request) {
	var account Account
	var resultFind struct {
		Value float64
	}
	json.NewDecoder(r.Body).Decode(&account)
	errFind := accountsCollection.FindOne(
		context.Background(),
		bson.M{
			"name":     account.Name,
			"password": account.Password,
		},
	).Decode(&resultFind)
	if errFind != nil {
		json.NewEncoder(w).Encode(bson.M{
			"message":   "account name or password not right",
			"errorCode": 1,
		})
		return
	}
	jwt := generateJWT(account.Name)
	r.AddCookie(&http.Cookie{
		Name:  cookieTokenName,
		Value: jwt,
	})
	// TODO: here to string it into redis
	json.NewEncoder(w).Encode(bson.M{
		"errorCode": 0,
		"data": bson.M{
			"name":  account.Name,
			"token": jwt,
		},
	})
}

func handleRegister(w http.ResponseWriter, r *http.Request) {
	var account Account
	var resultFind struct {
		Value float64
	}
	json.NewDecoder(r.Body).Decode(&account)
	errFind := accountsCollection.FindOne(
		context.Background(),
		bson.M{"name": account.Name},
	).Decode(&resultFind)
	if errFind == nil {
		json.NewEncoder(w).Encode(bson.M{
			"message":   "account has been register",
			"errorCode": 1,
		})
		return
	}
	accountsCollection.InsertOne(
		context.Background(),
		bson.D{
			primitive.E{Key: "name", Value: account.Name},
			primitive.E{Key: "password", Value: account.Password},
		},
	)
	jwt := generateJWT(account.Name)
	r.AddCookie(&http.Cookie{
		Name:  cookieTokenName,
		Value: jwt,
	})
	json.NewEncoder(w).Encode(bson.M{
		"errorCode": 0,
		"data": bson.M{
			"name":  account.Name,
			"token": jwt,
		},
	})
}

func handleGetUserInfo(w http.ResponseWriter, r *http.Request) {
	cookie, _ := r.Cookie(cookieTokenName)
	claims := jwt.MapClaims{}
	jwt.ParseWithClaims(cookie.Value, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(cookieTokenName), nil
	})
	fmt.Println(claims["user"])
	json.NewEncoder(w).Encode(bson.M{
		"errorCode": 0,
		"data": bson.M{
			"name":  claims["user"],
			"token": cookie.Value,
		},
	})
}

func handleRoute() {
	r := mux.NewRouter()
	r.HandleFunc("/api/userInfo", handleGetUserInfo).Methods(http.MethodOptions, http.MethodGet)
	r.HandleFunc("/api/register", handleRegister).Methods(http.MethodOptions, http.MethodPost)
	r.HandleFunc("/api/login", handleLogin).Methods(http.MethodOptions, http.MethodPost)
	r.HandleFunc("/api/word", getWords).Methods(http.MethodGet)
	r.HandleFunc("/api/word", createWord).Methods(http.MethodOptions, http.MethodPost)
	r.HandleFunc("/api/word/{id}", updateWord).Methods(http.MethodPatch, http.MethodOptions)
	r.HandleFunc("/api/word/{id}", deleteWord).Methods(http.MethodDelete, http.MethodOptions)
	r.Use(loggingMiddleware)
	r.Use(corsMiddleware)
	r.Use(tokenMiddleware)
	http.ListenAndServe(":8080", r)
}
