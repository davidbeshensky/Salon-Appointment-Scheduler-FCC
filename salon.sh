#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES_MENU() {
  echo -e "\n~~~ MY SALON ~~~"
  echo -e "\nHere are the services we have to offer:"
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done
  echo "Enter the service number you would like:"
  read SERVICE_ID_SELECTED  

  CHECK_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  if [[ -z $CHECK_SERVICE ]]
  then
    echo -e "\ninvalid service number. Please try again"
    SERVICES_MENU
  else
    echo "enter customer phone"
    read CUSTOMER_PHONE

    CHECK_CUSTOMER=$($PSQL "SELECT customer_id, name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CHECK_CUSTOMER ]]
    then
      echo "enter customer name"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    echo "enter service time"
    read SERVICE_TIME
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')")
    echo "I have put you down for a $CHECK_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
   
  fi
}

SERVICES_MENU
