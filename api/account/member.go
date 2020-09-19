package account

import (
	"errors"
	"regexp"

	"../database"
	"github.com/twinj/uuid"
)

type Account struct {
	Member Member `json:"member"`
	User   User   `json:"user"`
	Sso    []Sso  `json:"sso"`
}

type Member struct {
	Id   string `json:"id" db:"id"`
	Name string `json:"name" db:"name"`
}

type User struct {
	Id       string `json:"id" db:"id"`
	Username string `json:"username" db:"username"`
	Password string `json:"password" db:"password"`
}

type Sso struct {
	Id        string `json:"id" db:"id"`
	Token     string `json:"token" db:"token"`
	SsoTypeId string `json:"ssoTypeId" db:"ssoTypeId"`
}

type SsoType struct {
	Id     string `json:"id" db:"id"`
	Source string `json:"source" db:"source"`
}

func Login(account *Account) error {
	selectStatement := "SELECT BIN_TO_UUID(`member`.`id`) AS memberId " +
		", `member`.`name` " +
		", COALESCE(BIN_TO_UUID(`user`.`id`), '') AS userId " +
		", COALESCE(`user`.`username`, '') AS username " +
		", COALESCE(`user`.`password`, '') AS password " +
		", COALESCE(BIN_TO_UUID(`sso`.`id`), '') AS ssoId " +
		", COALESCE(`sso`.`token`, '') AS token " +
		", COALESCE(BIN_TO_UUID(`sso`.`ssoTypeId`), '') AS ssoTypeId " +
		"FROM      `member` " +
		"LEFT JOIN `user`    ON `member`.`id` = `user`.`memberId` " +
		"LEFT JOIN `sso`     ON `member`.`id` = `sso`.`memberId` "

	whereClause := ""
	vars := make([]interface{}, 2)
	errorMessage := ""

	if &account.User != nil && &account.User.Username != nil && &account.User.Password != nil && account.User.Password != "" {
		whereClause = "WHERE LOWER(`user`.`username`) = LOWER(?) " +
			"AND   `user`.`password` = ?"

		vars[0] = account.User.Username
		vars[1] = account.User.Password

		errorMessage = "invalid username or password"
		account.Sso = make([]Sso, 1)
		account.Sso[0] = Sso{}
	} else if &account.Sso != nil && len(account.Sso) == 1 && account.Sso[0].Token != "" && &account.Sso[0].SsoTypeId != nil && account.Sso[0].SsoTypeId != "" {
		whereClause = "WHERE `sso`.`token` = ? " +
			"AND `sso`.`ssoTypeId` = ?"

		vars[0] = account.Sso[0].Token
		vars[1] = account.Sso[0].SsoTypeId
		errorMessage = "invalid sso credentials"
	} else {
		return errors.New("account must have either a user or an sso login")
	}

	result, err := database.DB.Query(selectStatement+whereClause, vars...)

	if err != nil {
		return err
	} else if !result.Next() {
		return errors.New(errorMessage)
	}

	err = result.Scan(&account.Member.Id, &account.Member.Name, &account.User.Id, &account.User.Username, &account.User.Password, &account.Sso[0].Id, &account.Sso[0].Token, &account.Sso[0].SsoTypeId)
	return err
}

func Create(account *Account) error {
	if account == nil || &account.Member == nil || account.Member.Name == "" {
		return errors.New("account needs to have a name")
	} else if &account.User != nil && &account.User.Username != nil && &account.User.Password != nil && account.User.Password != "" {
		matched, err := regexp.MatchString("(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])", account.User.Username)
		if err == nil && matched {
			return createViaUser(account)
		} else {
			return errors.New("username must be an email address")
		}
	} else if &account.Sso != nil && len(account.Sso) == 1 && account.Sso[0].Token != "" && &account.Sso[0].SsoTypeId != nil && account.Sso[0].SsoTypeId != "" {
		return createViaSso(account)
	} else {
		return errors.New("account must have either a user or an sso login")
	}
}

func createViaUser(account *Account) error {
	account.Member.Id = uuid.NewV4().String()
	account.User.Id = uuid.NewV4().String()

	exists, err := database.Exists("user", "username", account.User.Username)
	if err != nil {
		return err
	} else if exists {
		return errors.New("username unavailable")
	}

	err = database.Insert("member", account.Member, nil, nil)
	if err != nil {
		return err
	}

	err = database.Insert("user", account.User, []string{"memberId"}, []interface{}{account.Member.Id})

	return err
}

func createViaSso(account *Account) error {
	account.Member.Id = uuid.NewV4().String()
	account.Sso[0].Id = uuid.NewV4().String()

	result, err := database.DB.Query("SELECT BIN_TO_UUID(`id`) AS id, `source` FROM `ssoType` WHERE `id` = UUID_TO_BIN(?);", account.Sso[0].SsoTypeId)

	if err != nil {
		return err
	} else if !result.Next() {
		return errors.New("no sso type with this id")
	}

	result, err = database.DB.Query("SELECT COUNT(`id`) AS c FROM `sso` WHERE `token` = ? AND `ssoTypeId` = UUID_TO_BIN(?);", account.Sso[0].Token, account.Sso[0].SsoTypeId)
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
		return errors.New("this sso already exists")
	}

	err = database.Insert("member", account.Member, nil, nil)
	if err != nil {
		return err
	}

	err = database.Insert("sso", account.Sso[0], []string{"memberId"}, []interface{}{account.Member.Id})

	return err
}

func SsoTypes() ([]SsoType, error) {
	result, err := database.DB.Query("SELECT BIN_TO_UUID(`id`) AS id, `source` FROM `ssoType`")
	if err != nil {
		return nil, err
	}

	ssoTypes := make([]SsoType,)
	for result.Next() {

	}

	var c int
	err = result.Scan(&c)

	if err != nil {
		return nil, err
	} else if c != 0 {
		return errors.New("this sso already exists")
	}
}
