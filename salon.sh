#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"
MAIN()
{
  GET_SERVICES_FROM_DB=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$GET_SERVICES_FROM_DB" | while read SERVICE_ID BAR NAME BAR
  do
    echo $SERVICE_ID")" $NAME
  done
  read SERVICE_ID_SELECTED
  GET_CHOSEN_SERVICE_NAME_FROM_DB=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $GET_CHOSEN_SERVICE_NAME_FROM_DB ]]
  then
    #service not found
    echo -e "\nI could not find that service. What would you like today?"
    MAIN
  else
    #service found
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      #insert into customers
      INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    echo -e "\nWhat time would you like your$GET_CHOSEN_SERVICE_NAME_FROM_DB, $CUSTOMER_NAME?"
    read SERVICE_TIME
    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #insert into appointments
    INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a$GET_CHOSEN_SERVICE_NAME_FROM_DB at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN
