package database

import (
	"database/sql"
	"errors"
	"reflect"
	"strings"
)

var DB *sql.DB

func Insert(table string, object interface{}, additionalColumns []string, additionalValues []interface{}) error {
	return upsert(table, object, false, additionalColumns, additionalValues)
}

func Update(table string, object interface{}, additionalColumns []string, additionalValues []interface{}) error {
	return upsert(table, object, true, additionalColumns, additionalValues)
}

func upsert(table string, object interface{}, isUpdate bool, additionalColumns []string, additionalValues []interface{}) error {
	statement := "INSERT INTO `" + table + "` (" // col1, col2
	values := ") VALUES ("                       // ?, ?
	v := reflect.ValueOf(object)

	if isUpdate {
		statement = "UPDATE `" + table + "` SET"
		values = ""
	}

	for i := 0; i < v.Type().NumField(); i++ {
		if v.Field(i).CanInterface() {
			additionalColumns = append(additionalColumns, getColumn(v.Type().Field(i)))
			additionalValues = append(additionalValues, v.Field(i).Interface())
		}
	}

	for i := 0; i < len(additionalColumns); i++ {
		if i > 0 {
			if !isUpdate {
				statement += ", "
			}
			values += ", "
		}
		column := additionalColumns[i]
		value := "?"

		if column == "id" || strings.HasSuffix(column, "Id") {
			value = "UUID_TO_BIN(?)"
		}

		if isUpdate {
			values += "`" + column + "` = " + value

			if column == "id" {
				additionalValues = append(additionalValues, additionalValues[i])
			}
		} else {
			statement += "`" + column + "`"
			values += value
		}

	}
	if isUpdate {
		values += " WHERE `id` = UUID_TO_BIN(?);"
	} else {
		values += ");"
	}

	rows, err := DB.Exec(statement+values, additionalValues...)
	if err != nil {
		return err
	}

	n, err := rows.RowsAffected()
	if err != nil {
		return err
	} else if n != 1 {
		operation := "insert to"
		if isUpdate {
			operation = "update"
		}
		return errors.New("failed to " + operation + " " + table)
	}

	return nil
}

func getColumn(field reflect.StructField) string {
	column, ok := field.Tag.Lookup("db")
	if !ok {
		column = field.Name
	}
	return column
}

func Exists(table string, column string, value interface{}) (bool, error) {
	result, err := DB.Query("SELECT COUNT(`id`) AS c FROM `"+table+"` WHERE `"+column+"` = ?;", value)

	if err != nil {
		return false, err
	} else if !result.Next() {
		return false, errors.New("query produced no results")
	}

	var c int
	err = result.Scan(&c)

	if err != nil {
		return false, err
	}

	return c > 0, nil
}
