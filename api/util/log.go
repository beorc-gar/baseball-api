package util

import (
	"net/http"
	"strings"
)

func ErrorResponse(err error, w http.ResponseWriter) {
	if err != nil {
		w.Write([]byte("{\"error\":\"" + strings.Replace(err.Error(), "\"", "\\\"", -1) + "\"}"))
	}
}
