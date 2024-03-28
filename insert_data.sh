#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# function insert_data() {
#   INSERT_RESULT=$($PSQL "insert into teams(name) values('$1');")

#   if [[ $INSER_RESULT == "INSERT 0 1" ]]
#   then
#     echo "Insert into teams, $1"
#   fi
# }

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # check if it's the frist row
  if [[ $YEAR != "year" ]]
  then
    # echo "Year: $YEAR, Round: $ROUND, Winner: $WINNER, Opponent: $OPPONENT, Winner Goals: $WINNER_GOALS, Opponent Goals: $OPPONENT_GOALS"
    WINNER_NAME=$($PSQL "select name from teams where name='$WINNER'")
    OPPONENT_NAME=$($PSQL "select name from teams where name='$OPPONENT'")

    # check if the winner team already there
    if [[ -z $WINNER_NAME ]]
    then
      INSERT_RESULT=$($PSQL "insert into teams(name) values('$WINNER');")

      if [[ $INSER_RESULT == "INSERT 0 1" ]]
      then
        echo "Insert into teams, $WINNER"
      fi
      
    fi

    # # check if the opponent team already there
    if [[ -z $OPPONENT_NAME ]]
    then
      INSERT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT');")

      if [[ $INSER_RESULT == "INSERT 0 1" ]]
      then
        echo "Insert into teams, $OPPONENT"
      fi
    
    fi
    
  fi
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # if it isn't the first row
  if [[ $YEAR != 'year' ]]
  then

    # YEAR ROUND WINNER_GOALS OPPONENT_GOALS WINNER OPPONENT
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    RESULT=$($PSQL "insert into 
    games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi

done
