package main

import (
	"database/sql"
	"net/http"

	"./database"
	"./endpoint"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
)

func main() {
	//todo get connection string based on zone
	db, err := sql.Open("mysql", "root:Se4Q2Lp-3587@tcp(localhost)/baseball")
	if err != nil {
		//todo handle it (fatal, can't continue.)
	}
	database.DB = db
	defer database.DB.Close()

	router := mux.NewRouter()

	router.HandleFunc("/account/create", endpoint.CreateAccount).Methods("POST")
	router.HandleFunc("/account/login", endpoint.Login).Methods("POST")

	http.ListenAndServe(":8080", router)
}
