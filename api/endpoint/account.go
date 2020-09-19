package endpoint

import (
	"encoding/json"
	"net/http"

	"../account"
	"../util"
)

//TODO do not return passwords and sso tokens

func CreateAccount(w http.ResponseWriter, req *http.Request) {
	var acc account.Account

	err := json.NewDecoder(req.Body).Decode(&acc)

	if err != nil {
		util.ErrorResponse(err, w)
		return
	}

	err = account.Create(&acc)

	if err != nil {
		util.ErrorResponse(err, w)
		return
	}

	jsonData, err := json.Marshal(acc)

	if err != nil {
		util.ErrorResponse(err, w)
		return
	}

	w.Write(jsonData)
}

func Login(w http.ResponseWriter, req *http.Request) {
	var acc account.Account

	err := json.NewDecoder(req.Body).Decode(&acc)

	if err != nil {
		util.ErrorResponse(err, w)
		return
	}

	err = account.Login(&acc)

	if err != nil {
		util.ErrorResponse(err, w)
		return
	}

	jsonData, err := json.Marshal(acc)

	if err != nil {
		util.ErrorResponse(err, w)
		return
	}

	w.Write(jsonData)
}
