package league

import (
	"errors"

	"../database"
	"github.com/twinj/uuid"
)

type League struct {
	Id     string `json:"id"`
	Name   string `json:"name"`
	Public bool   `json:"public"`
}

func createLeague(league *League) error {
	if league == nil || &league.Name == nil || league.Name == "" {
		return errors.New("league needs to have a name")
	}

	//todo use db.exists
	result, err := database.DB.Query("SELECT COUNT(`id`) AS c FROM `league` WHERE `name` = ?;", league.Name)

	if err != nil {
		return err
	} else if !result.Next() {
		return errors.New("query produced no results")
	}

	var c int
	err = result.Scan(&c)

	if err != nil {
		return err
	} else if c != 0 {
		return errors.New("league name unavailable")
	}

	league.Id = uuid.NewV4().String()
	if &league.Public == nil {
		league.Public = true
	}

	//todo use db.insert
	rows, err := database.DB.Exec("INSERT INTO `league` (`id`, `name`, `public`) VALUES (UUID_TO_BIN(?), ?, ?);", league.Id, league.Name, league.Public)
	if err != nil {
		return err
	}

	n, err := rows.RowsAffected()
	if err != nil {
		return err
	} else if n != 1 {
		return errors.New("failed to insert member")
	}
}
