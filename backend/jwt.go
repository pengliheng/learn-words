package main

import (
	"time"

	"github.com/dgrijalva/jwt-go"
)

var mySigningKey = []byte(cookieTokenName)

func generateJWT(user string) string {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["authorized"] = true
	claims["user"] = user
	claims["exp"] = time.Now().Add(time.Minute * 30).Unix()
	tokenString, err := token.SignedString(mySigningKey)
	if err != nil {
		return ""
	}
	tokenRedis = append(tokenRedis, tokenString)
	return tokenString
}
