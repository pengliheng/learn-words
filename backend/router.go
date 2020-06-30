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

// VocabularyRate is the type structure pf vocabulary
type VocabularyRate struct {
	ID   primitive.ObjectID
	Rate int
}

// Account is a account type
type Account struct {
	Name       string
	Password   string
	Vocabulary []VocabularyRate
}

// Vocabulary is a vocabulary structure
type Vocabulary struct {
	ID       primitive.ObjectID
	Name     string
	Author   string
	CreateAt time.Time
	UpdateAt time.Time
	Image    []string
}

const cookieTokenName = "Authorization"

// 获取所有单词
func getVocabularys(w http.ResponseWriter, r *http.Request) {
	ctx, cancelFunc := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancelFunc()
	cur, _ := vocabularysCollection.Find(ctx, bson.D{})
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

// 创建单词
func createVocabulary(w http.ResponseWriter, r *http.Request) {
	var vocabulary Vocabulary
	json.NewDecoder(r.Body).Decode(&vocabulary)
	result, err := vocabularysCollection.InsertOne(
		context.Background(),
		bson.D{
			primitive.E{Key: "name", Value: vocabulary.Name},
			primitive.E{Key: "author", Value: vocabulary.Author},
			primitive.E{Key: "createAt", Value: time.Now()},
			primitive.E{Key: "updateAt", Value: time.Now()},
			primitive.E{Key: "images", Value: getImage(vocabulary.Name)},
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

// 更新单词
func updateVocabulary(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r) // get params
	var vocabulary Vocabulary
	json.NewDecoder(r.Body).Decode(&vocabulary)
	objectID, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		log.Fatal(err)
	}
	result, err := vocabularysCollection.UpdateOne(
		context.Background(),
		bson.D{
			primitive.E{Key: "_id", Value: objectID},
		},
		bson.D{
			primitive.E{Key: "$set", Value: bson.D{
				primitive.E{Key: "name", Value: vocabulary.Name},
				primitive.E{Key: "author", Value: vocabulary.Author},
				primitive.E{Key: "updateAt", Value: time.Now()},
				primitive.E{Key: "images", Value: getImage(vocabulary.Name)},
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

// 删除单词
func deleteVocabulary(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r) // get params
	objectID, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		log.Fatal(err)
	}
	result, err := vocabularysCollection.DeleteOne(
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

// 登录
func handleLogin(w http.ResponseWriter, r *http.Request) {
	var account Account
	var resultFind Account
	json.NewDecoder(r.Body).Decode(&account)
	errFindNamePassword := accountsCollection.FindOne(
		context.Background(),
		bson.M{
			"name":     account.Name,
			"password": account.Password,
		},
	).Decode(&resultFind)
	if errFindNamePassword != nil {
		errFindName := accountsCollection.FindOne(
			context.Background(),
			bson.M{
				"name": account.Name,
			},
		).Decode(&resultFind)
		if errFindName != nil {
			// not register
			json.NewEncoder(w).Encode(bson.M{
				"message":   "account not exist",
				"errorCode": 1,
			})
		} else {
			json.NewEncoder(w).Encode(bson.M{
				"message":   "password not right",
				"errorCode": 2,
			})
		}
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
		"message":   "login success!",
		"data": bson.M{
			"name":  account.Name,
			"token": jwt,
		},
	})
}

// 登出
func handleLogout(w http.ResponseWriter, r *http.Request) {
	// Read cookie
	cookie, err := r.Cookie(cookieTokenName)
	if err != nil {
		return
	}
	i := indexOf(tokenRedis, cookie.Value)
	if i > -1 {
		tokenRedis = append(tokenRedis[:i], tokenRedis[i+1:]...)
	}
	json.NewEncoder(w).Encode(bson.M{
		"errorCode": 0,
		"message":   "logout success!",
	})
}

// 注册
func handleRegister(w http.ResponseWriter, r *http.Request) {
	var account Account
	var resultFind Account
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
			primitive.E{Key: "vocabulary", Value: []VocabularyRate{}},
		},
	)
	jwt := generateJWT(account.Name)
	r.AddCookie(&http.Cookie{
		Name:  cookieTokenName,
		Value: jwt,
	})
	json.NewEncoder(w).Encode(bson.M{
		"errorCode": 0,
		"message":   "account register success",
		"data": bson.M{
			"name":  account.Name,
			"token": jwt,
		},
	})
}

// 获取用户信息
func handleGetUserInfo(w http.ResponseWriter, r *http.Request) {
	cookie, _ := r.Cookie(cookieTokenName)
	claims := jwt.MapClaims{}
	jwt.ParseWithClaims(cookie.Value, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(cookieTokenName), nil
	})
	var resultFind Account
	errFindName := accountsCollection.FindOne(
		context.Background(),
		bson.M{
			"name": claims["user"],
		},
	).Decode(&resultFind)
	fmt.Println(33333,errFindName, &resultFind, claims)
	if errFindName != nil {
		// not find user
		json.NewEncoder(w).Encode(bson.M{
			"message":   "account not exist",
			"errorCode": 1,
		})
	}
	// find user
	json.NewEncoder(w).Encode(bson.M{
		"errorCode": 0,
		"data": bson.M{
			"userInfo": &resultFind,
			"name":     claims["user"],
			"token":    cookie.Value,
		},
	})
}

func handleRoute() {
	r := mux.NewRouter()
	r.HandleFunc("/api/userInfo", handleGetUserInfo).Methods(http.MethodOptions, http.MethodGet)
	r.HandleFunc("/api/register", handleRegister).Methods(http.MethodOptions, http.MethodPost)
	r.HandleFunc("/api/login", handleLogin).Methods(http.MethodOptions, http.MethodPost)
	r.HandleFunc("/api/logout", handleLogout).Methods(http.MethodOptions, http.MethodPost)
	r.HandleFunc("/api/vocabulary", getVocabularys).Methods(http.MethodGet)
	r.HandleFunc("/api/vocabulary", createVocabulary).Methods(http.MethodOptions, http.MethodPost)
	r.HandleFunc("/api/vocabulary/{id}", updateVocabulary).Methods(http.MethodPatch, http.MethodOptions)
	r.HandleFunc("/api/vocabulary/{id}", deleteVocabulary).Methods(http.MethodDelete, http.MethodOptions)
	r.Use(loggingMiddleware)
	r.Use(corsMiddleware)
	r.Use(tokenMiddleware)
	http.ListenAndServe(":8080", r)
}
