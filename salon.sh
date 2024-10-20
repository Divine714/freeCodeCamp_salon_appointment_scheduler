#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Scheduler ~~~~~\n"

MAIN() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "What kind of appointment would you like to schedule?" 
  

  SERVICE_OPTIONS=$($PSQL "SELECT * FROM services")
  echo "$SERVICE_OPTIONS" | while read SERVICE_ID BAR NAME
  do
    ID=$(echo $SERVICE_ID | sed 's/ //g')
    NAME=$(echo $NAME | sed 's/^ *//g')
    echo "$ID) $NAME"
  done
  echo -e "4) Exit"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT ;;
    2) MAKE_APPOINTMENT ;;
    3) MAKE_APPOINTMENT ;;
    4) EXIT ;;

    *) MAIN "That was not a valid option. What kind of appointment would you like to schedule?" ;;
  esac
  

}

MAKE_APPOINTMENT() {
  # select appointment type
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  echo $SERVICE_SELECTED
  # get phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'") 
  # check if customer info already exists
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_NEW_CUST=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like to schedule?"
  read SERVICE_TIME
  # insert appointment

  INSERT_HAIRCUT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', '$SERVICE_ID_SELECTED', $CUSTOMER_ID)")
  echo -e "\nI have put you down for a$SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT() {
  echo -e "\nThank you for considering us.\n"
}

MAIN
