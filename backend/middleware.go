package main

import (
	"log"
	"net/http"
)

var whiteURL = []string{
	"/api/login",
	"/api/logout",
	"/api/register",
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Println(r.RequestURI, r.Method)
		next.ServeHTTP(w, r)
	})
}

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		if len(r.Header["Origin"]) > 0 {
			w.Header().Set("Access-Control-Allow-Origin", r.Header["Origin"][0])
		}
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, PATCH, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, Access-Control-Request-Headers, Access-Control-Request-Method, Connection, Host, Origin, User-Agent, Referer, Cache-Control, X-header")
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func tokenMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if indexOf(whiteURL, r.URL.Path) > -1 {
			next.ServeHTTP(w, r)
			return
		}
		cookie, err := r.Cookie(cookieTokenName)
		if err == nil {
			if indexOf(tokenRedis, cookie.Value) > -1 {
				next.ServeHTTP(w, r)
				return
			}
		}
		http.Error(w, "Not authorized", 401)
	})
}
