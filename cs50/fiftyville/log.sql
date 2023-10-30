-- Keep a log of any SQL queries you execute as you solve the mystery.
/*
    I MUST SAY THAT THIS WAS THE BESTEST PROBLEMSET AND MOST FUNNEST TO DO...GREAT GOING ON THIS ONE.

Keep a log of any SQL queries you execute as you solve the mystery.
1. Check which tables I have to work with in the database so type .tables at the sqlite prompt.


2. I know when and on which street the crime took place, so based on this
info I can check the crime_scene_reports table.
First check the schema of the crime_scene_reports table, to see which fields I have to work with.
sqlite> .schema crime_scene_reports
CREATE TABLE crime_scene_reports (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    street TEXT,
    description TEXT,
    PRIMARY KEY(id)
);

3a. - All I know is that the theft took place on July 28, 2021 and that it took place on Humphrey Street.
Select from the crime_scene_reports table to see what the data stored looks like, limitting the result set
to show only the first 5 records.
*/
SELECT
    *
FROM
    crime_scene_reports
LIMIT 5;

/*
3b. - Now select only the crime sceen records that took place on July 28, 2021, and on Humphrey Street.
This reveals crime screen record with id 295, which details the logged entry of the theft of the cs50 duck,
which is what I am interested in. So lets examine this screen sceen record further.
Checking the description of record 295, I see:
  - the approximate time which the theft occured
  - Exactly where the crime occured, at the bakery - Humphrey Street bakery
  - Interviews were conducted with three witnesses - key to note, all 3 witnesses mentioned the bakery.
So, who are the 3 witnesses, they may be potential suspects...
Who conducted the interviews...
How long after the crime recorded was the interviews conducted...
*/
SELECT
    *
FROM
    crime_scene_reports
WHERE
    street = 'Humphrey Street'
AND year = 2021 AND month = 7 AND day = 28;

/*
4. So I have the crime record for the crime of interest, theft of the cs50 duck.
Now how else is this crime record related to other aspects of the database, so I may gain more insights.
Well, I know the theft occured at the bakery, which all 3 witnesses mentioned, and their is a
table called bakery_security_logs which presumably stores the events on a daily basis.
So it may prove helpful to check the bakery security log record entries for data around the same date and time
of the recorded theft.
Recall the logged entry of the crime from the crime sceen table tells me the approximate time the theft took place.
So. check the schema for the bakery_security_logs table.
sqlite> .schema bakery_security_logs
CREATE TABLE bakery_security_logs (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    activity TEXT,
    license_plate TEXT,
    PRIMARY KEY(id)
);
Key to note is that I can check for the date with fields year, month and day, but also for the time with fields hour and minute.
The activity field of datatype Text also suggest that I may be able to get some details of what happened at that date and time,
which may very well be related to or linked to the same event which is recorded within the crime sceen table.

I also note the license_plate field and that their is a table called people which also has a license_plate field, of which the 2 may be linked.
So lets check the bakery_secuurity_logs table for any data around the same date and time the cs50 theft occured.
First Select the description from the crime_scene_reports table for July 28, 2021 on Humphrey Street. I am looking for the time of the theft,
which is 10:15am.
*/
SELECT
    description
FROM
    crime_scene_reports
WHERE
    street = 'Humphrey Street'
AND year = 2021 AND month = 7 AND day = 28;

/*
After getting the time of theft, use time to fetch records from the bakery_security_logs table
*/
SELECT
    *
FROM
    bakery_security_logs
WHERE
    year = 2021 AND month = 7 and day = 28 AND hour = 10 and minute = 15;

/*
This query returns no records...So lets remove the minute of 15 so I can see what records exists
on the same day after 10 am, so first do a count, which indicates 14 records of interest.
*/
SELECT
    count(*)
FROM
    bakery_security_logs
WHERE
    year = 2021 AND month = 7 and day = 28 AND hour = 10;

/*
Now view the records of interest and do some illiminations.
Based on the data in the bakery security logs table I see that after 10:14am, a few
persons exited the bakery location, based on the exit status within the activity field, and I see their
license_plate.
These exit individuals based on license plate are now suspects, since they left the bakery soon after the theft was reported.
*/
SELECT
    *
FROM
    bakery_security_logs
WHERE
    year = 2021 AND month = 7 and day = 28 AND hour = 10;

/*
Lets see who these people are, by linking the bakery_security_logs table and the people table by the licese_plate fields.
So Find all persons with a license plate that match the license plate of the records with activity of exit, within the
bakery_security_logs table, on July 28, 2021 at the 10th hour.
First check the schema of the people table
sqlite> .schema people
CREATE TABLE people (
    id INTEGER,
    name TEXT,
    phone_number TEXT,
    passport_number INTEGER,
    license_plate TEXT,
    PRIMARY KEY(id)
);
View top 5 records from the people table
*/
SELECT
    *
FROM
    people
LIMIT 5;

/*
sqlite> SELECT
   ...>     *
   ...> FROM
   ...>     people
   ...> LIMIT 5;
+--------+---------+----------------+-----------------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate |
+--------+---------+----------------+-----------------+---------------+
| 205082 | Pamela  | (113) 555-7544 | 1050247273      | 5CIO816       |
| 210245 | Jordan  | (328) 555-9658 | 7951366683      | HW0488P       |
| 210641 | Heather | (502) 555-6712 | 4356447308      | NULL          |
| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       |
| 222194 | Ronald  | (321) 555-6083 | 4959515588      | 9XPY28H       |
+--------+---------+----------------+-----------------+---------------+

I see the license plate data, but also I recognise that passport_number is also tied to a person as well,
and I recall that within the database their is a table called passengers, which I may link with to get more details..
But let's find all persons with a license plate that match the license plate of the records with activity of exit, within the
bakery_security_logs table, on July 28, 2021 at the 10th hour.
*/
SELECT
    p.*,
    b. activity,
    b.license_plate
FROM
    people p
JOIN
    bakery_security_logs b
ON
    p.license_plate = b.license_plate
WHERE p.license_plate
IN
(
    SELECT
        license_plate
    FROM
        bakery_security_logs
    WHERE
        year = 2021 AND month = 7 and day = 28 AND hour = 10 AND activity = 'exit'
)
AND
    b.activity = 'exit';
/*
+--------+---------+----------------+-----------------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate |
+--------+---------+----------------+-----------------+---------------+
| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       |
| 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       |
| 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
| 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       |
| 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
+--------+---------+----------------+-----------------+---------------+
So these are the persons who exited the bakery soon after the reported theft.
*/


/*
5. Now lets check the interview table for the 3 eye witness statement on July 28, 2021.
The interviews schema is as follows:
sqlite> .schema interviews
CREATE TABLE interviews (
    id INTEGER,
    name TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    transcript TEXT,
    PRIMARY KEY(id)
);

I see name and transcript fields which may be of good use to me.
So find any interview record which makes mention of a theif on the day in question.
*/
SELECT
    name,
    transcript
FROM
    interviews
WHERE
    year = 2021 AND month = 7 AND day = 28 AND transcript LIKE '%thief%';

/*
| Ruth    | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away.
If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.
                                                 |
| Eugene  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery,
I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
                                                                |
| Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call,
I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the
person on the other end of the phone to purchase the flight ticket. |

The 3 eyewitnesses are Ruth, Eugene and Raymond.

Recall earlier I found a few records of persons leaving the bakery 'location' soon after the reported theft. Now Ruth has confirmed
indeed the theif left the 'Parking Lot' of the bakery...But within 10 minutes of the theft.
Now the theft was reported approximately 10:15am as specified in the crime_scene_reports table's description field.
*/
SELECT
    description
FROM
    crime_scene_reports
WHERE
    street = 'Humphrey Street'
AND year = 2021 AND month = 7 AND day = 28 AND description LIKE '%cs50%';

/*
This means within 10 minutes of the theft according to Ruth will take the time to 10:25am, which means anyone leaving
the bakery parking lot between 10:15am and 10:25am is a suspect.
So refine the earlier query to get all the persons with an exit activity status on the bakery_security_logs table between
10:15am and 10:25am.
*/
SELECT
    p.*,
    b. activity,
    b.license_plate,
    b.hour,
    b.minute
FROM
    people p
JOIN
    bakery_security_logs b
ON
    p.license_plate = b.license_plate
WHERE
     b.year = 2021 AND b.month = 7 and b.day = 28 AND b.hour = 10 AND
    b.activity = 'exit' AND minute BETWEEN 15 AND 25;

/*
Now I have 8 suspects....
+--------+---------+----------------+-----------------+---------------+----------+---------------+------+--------+
|   id   |  name   |  phone_number  | passport_number | license_plate | activity | license_plate | hour | minute |
+--------+---------+----------------+-----------------+---------------+----------+---------------+------+--------+
| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       | exit     | 5P2BI95       | 10   | 16     |
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | exit     | 94KL13X       | 10   | 18     |
| 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       | exit     | 6P58WS2       | 10   | 18     |
| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | exit     | 4328GD8       | 10   | 19     |
| 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       | exit     | G412CB7       | 10   | 20     |
| 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | exit     | L93JTIZ       | 10   | 21     |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | exit     | 322W7JE       | 10   | 23     |
| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       | exit     | 0NTHK55       | 10   | 23     |
+--------+---------+----------------+-----------------+---------------+----------+---------------+------+--------+

Now recall the second eyewitness statement from Eugene:
| Eugene  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery,
I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.

Eugene recognizes the theif, and mentioned seeing the thief earlier at an ATM withdrawing some money.
Now the key things to note from Eugene's eyewitness statement are:
    1. ATM - there is a bank_accounts table and atm_transactions table.
    2. Location of the ATM - on Leggett Street
    3. Type of transaction theif was doing - WITHDRAW

These 3 points will now lead me to identifying who the theif is. How?
Well, let's look at the schema for the bank_accounts table:

sqlite> .schema bank_accounts
CREATE TABLE bank_accounts (
    account_number INTEGER,
    person_id INTEGER,
    creation_year INTEGER,
    FOREIGN KEY(person_id) REFERENCES people(id)
);

Right away I see persone_id field which is also a FOREIGN KEY referencing the people table id field.
And I already have a list of suspects who left the bakery parking lot.

More helpful will be to check the schema of the atm_transactions table since the theif was doing a withdrawal.

sqlite> .schema atm_transactions
CREATE TABLE atm_transactions (
    id INTEGER,
    account_number INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    atm_location TEXT,
    transaction_type TEXT,
    amount INTEGER,
    PRIMARY KEY(id)
);

I now see that the bank_accounts table can be linked with the atm_transactions table by the account_number, which
I can tie to the person by the person_id in the bank_accounts table referencing the people table, which would then link
to all the suspect ids obtained from those who left the bakery parking lot within 10 minutes of the reported theft.

So get the bank accounts for all the suspects.
*/
SELECT
    *
FROM
    people p, bank_accounts ba
WHERE
    p.id = ba.person_id
AND
    ba.person_id
IN
(
    SELECT
        p.id
    FROM
        people p
    JOIN
        bakery_security_logs b
    ON
        p.license_plate = b.license_plate
    WHERE p.license_plate
    IN
    (
        SELECT
            license_plate
        FROM
            bakery_security_logs
        WHERE
            year = 2021 AND month = 7 and day = 28 AND hour = 10 AND activity = 'exit'
    )
    AND
        b.activity = 'exit' AND minute BETWEEN 15 AND 25
);
/*
Now my suspect list has been reduced to 5 person:
+--------+-------+----------------+-----------------+---------------+----------------+-----------+---------------+
|   id   | name  |  phone_number  | passport_number | license_plate | account_number | person_id | creation_year |
+--------+-------+----------------+-----------------+---------------+----------------+-----------+---------------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       | 686048    | 2010          |
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       | 514354    | 2012          |
| 396669 | Iman  | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       | 396669    | 2014          |
| 467400 | Luca  | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       | 467400    | 2014          |
| 243696 | Barry | (301) 555-4174 | 7526138472      | 6P58WS2       | 56171033       | 243696    | 2018          |
+--------+-------+----------------+-----------------+---------------+----------------+-----------+---------------+

Now lets check from the 5 suspects who did WITHDRAWALS from the ATM on Leggett Street, on July 28, 2021 before 10:15 am.
Check the schema of the atm_transactions table:

sqlite> .schema atm_transactions
CREATE TABLE atm_transactions (
    id INTEGER,
    account_number INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    atm_location TEXT,
    transaction_type TEXT,
    amount INTEGER,
    PRIMARY KEY(id)
);

I can link the bank_accounts table with the atm_transactions table by the account number of a person,
and I can get the type of transaction done from the transaction_type table, the ATM location from the
atm_location table and the date from the fields year, month and day.
But first lets see how the data is represented in the atm_transactions table.

Select everything limiting the result set to only 5 records.
*/
SELECT
    *
FROM
    atm_transactions
LIMIT 5;
/*
+----+----------------+------+-------+-----+----------------------+------------------+--------+
| id | account_number | year | month | day |     atm_location     | transaction_type | amount |
+----+----------------+------+-------+-----+----------------------+------------------+--------+
| 1  | 57022441       | 2021 | 7     | 26  | Humphrey Lane        | deposit          | 40     |
| 2  | 39167741       | 2021 | 7     | 26  | Daboin Sanchez Drive | withdraw         | 40     |
| 3  | 93622979       | 2021 | 7     | 26  | Carvalho Road        | deposit          | 50     |
| 4  | 11605357       | 2021 | 7     | 26  | Humphrey Lane        | deposit          | 25     |
| 5  | 27362189       | 2021 | 7     | 26  | Humphrey Lane        | deposit          | 75     |
+----+----------------+------+-------+-----+----------------------+------------------+--------+

transaction_type is either deposit/withdraw which can be confirmed by:
*/
SELECT
    DISTINCT(transaction_type)
FROM
    atm_transactions;
/*
+------------------+
| transaction_type |
+------------------+
| deposit          |
| withdraw         |
+------------------+

Now lets get all the person who withdrew funds from the ATM on Leggett Street, on July 28, 2021 before 10:15 am.
*/
SELECT
    p.*,
    ba.account_number,
    a.atm_location,
    a.transaction_type
FROM
    people p, bank_accounts ba, atm_transactions a
WHERE
    p.id = ba.person_id
AND
    ba.account_number = a.account_number
AND
    ba.person_id
IN
(
    SELECT
        p.id
    FROM
        people p
    JOIN
        bakery_security_logs b
    ON
        p.license_plate = b.license_plate
    WHERE p.license_plate
    IN
    (
        SELECT
            license_plate
        FROM
            bakery_security_logs
        WHERE
            year = 2021 AND month = 7 and day = 28 AND hour = 10 AND activity = 'exit'
    )
    AND
        b.activity = 'exit' AND minute BETWEEN 15 AND 25
)
AND
    a.year = 2021 AND month = 7 AND day = 28
AND atm_location = 'Leggett Street'AND transaction_type = 'withdraw';


/*
I am now down to 4 suspects:
+--------+-------+----------------+-----------------+---------------+----------------+----------------+------------------+
|   id   | name  |  phone_number  | passport_number | license_plate | account_number |  atm_location  | transaction_type |
+--------+-------+----------------+-----------------+---------------+----------------+----------------+------------------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       | Leggett Street | withdraw         |
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       | Leggett Street | withdraw         |
| 396669 | Iman  | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       | Leggett Street | withdraw         |
| 467400 | Luca  | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       | Leggett Street | withdraw         |
+--------+-------+----------------+-----------------+---------------+----------------+----------------+------------------+


Now lets dig for more insight from the third and last eyewithness statement from Raymond:

| Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call,
I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the
person on the other end of the phone to purchase the flight ticket. |

Key things to note according to Raymond:
    1.Thief made a call right after the theft - call lasted less than a minute.
        - database has a phone_calls table
    2. Thief spoke to accomplice
    3. Thief told accomplice he/she wanted to leave Fiftyville on the first flight (earliest) the next day.
        - database has the following tables of interest: passenger, airports and flights.

    4. Thief told accomplice to purchase plane ticket for the first flight next day.

Lets check the schema of the phone_calls table:

sqlite> .schema phone_calls
CREATE TABLE phone_calls (
    id INTEGER,
    caller TEXT,
    receiver TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    duration INTEGER,
    PRIMARY KEY(id)
);

Interesting fields are:
    caller - may be the theif's phone number who called accomplice
    receiver - which may be the accomplice phone number who theif called and who also booked flight for theif
    year, month and day - to filter calls made around the time of the theft.
    duration - should be less than 1 minute, as according to eyewitness Raymond, the theif spoke for less than 1 minute to accomplice.

First find all phone calls made around the time period of the theft:
*/
SELECT
    *
FROM
    phone_calls
WHERE
    year = 2021 AND month = 7 AND day = 28 AND duration < 60;

/*
9 calls where made during the period of interest...
+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 221 | (130) 555-0289 | (996) 555-8899 | 2021 | 7     | 28  | 51       |
| 224 | (499) 555-9472 | (892) 555-8872 | 2021 | 7     | 28  | 36       |
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       |
| 251 | (499) 555-9472 | (717) 555-1342 | 2021 | 7     | 28  | 50       |
| 254 | (286) 555-6063 | (676) 555-6554 | 2021 | 7     | 28  | 43       |
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       |
| 261 | (031) 555-6622 | (910) 555-3251 | 2021 | 7     | 28  | 38       |
| 279 | (826) 555-1652 | (066) 555-9701 | 2021 | 7     | 28  | 55       |
| 281 | (338) 555-6650 | (704) 555-2131 | 2021 | 7     | 28  | 54       |
+-----+----------------+----------------+------+-------+-----+----------+

SO where to go from here to find the thief..
Well the people table has the phone numbers....

So to find the potential thief,
I need to get all the person who withdrew funds from the ATM on Leggett Street, on July 28, 2021 and who
is placed at the bakery exiting the bakery between 10:15am and 10:25am, and now
Who has placed a call on the same day and spoke for less than 1 minute.
*/
SELECT
    p.*,
    pc.receiver [Potential Accomplice],
    pc.duration
FROM
    people p
JOIN
    phone_calls pc
ON p.phone_number = pc.caller
WHERE
    pc.caller
IN
(
SELECT
    p.phone_number
FROM
    people p, bank_accounts ba, atm_transactions a
WHERE
    p.id = ba.person_id
AND
    ba.account_number = a.account_number
AND
    ba.person_id
IN
(
    SELECT
        p.id
    FROM
        people p
    JOIN
        bakery_security_logs b
    ON
        p.license_plate = b.license_plate
    WHERE p.license_plate
    IN
    (
        SELECT
            license_plate
        FROM
            bakery_security_logs
        WHERE
            year = 2021 AND month = 7 and day = 28 AND hour = 10 AND activity = 'exit'
    )
    AND
        b.activity = 'exit' AND minute BETWEEN 15 AND 25
)
AND
    a.year = 2021 AND month = 7 AND day = 28
AND atm_location = 'Leggett Street'AND transaction_type = 'withdraw'
)
AND
    year = 2021 AND month = 7 AND day = 28 AND duration < 60;

/*
Now I have 2 suspects as the theif but also the phone numbers for the potential accomplice.
So how do I find who the theif is?
Simply, which ever Potential Accomplice number called to book the first flight for next day is the the accomplice,
and the matching phone number for is the thief.
+--------+-------+----------------+-----------------+---------------+----------------------+----------+
|   id   | name  |  phone_number  | passport_number | license_plate | Potential Accomplice | duration |
+--------+-------+----------------+-----------------+---------------+----------------------+----------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | (375) 555-8161       | 45       |
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | (725) 555-3243       | 49       |
+--------+-------+----------------+-----------------+---------------+----------------------+----------+

So presumably the accomplice booked the flight for the thief after receiving the call from the thief.
This doesnt have to be the case as the accomplice could book the flight later in the day for next day. So I just need
to check which of the Potential Accomplice numbers booked the first flight for next day.

Lets examine a few tables of interest:
    1. airports
    2. flights
    3. passengers


RECALL Raymonds statement:

| Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call,
I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the
person on the other end of the phone to purchase the flight ticket. |

Based on this statement I just need to find the first flight out of Fiftyville airport on July 29, 2021 (the next day).
Then check the passport numbers for all the passengers on the first flight out of Fiftyville airport.

Now recall I now have 2 suspects:
+--------+-------+----------------+-----------------+---------------+----------------------+----------+
|   id   | name  |  phone_number  | passport_number | license_plate | Potential Accomplice | duration |
+--------+-------+----------------+-----------------+---------------+----------------------+----------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | (375) 555-8161       | 45       |
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | (725) 555-3243       | 49       |
+--------+-------+----------------+-----------------+---------------+----------------------+----------+

Its not likely that both Bruce and Diana are passengers on the first flight out of Fiftyville on July 29, 2021,
 thus the passport_number of the 2 remaining suspects is compared to the passenger list on the 29th of July 2021,
 where there is ia a match, then that person is the theif.

So the first thing I need to find is the Fiftyville airport
*/
SELECT
    *
FROM
    airports
WHERE
    city = 'Fiftyville';
/*
Fiftyville airport has id 8
+----+--------------+-----------------------------+------------+
| id | abbreviation |          full_name          |    city    |
+----+--------------+-----------------------------+------------+
| 8  | CSF          | Fiftyville Regional Airport | Fiftyville |
+----+--------------+-----------------------------+------------+

Now lets find the first flight which left Fiftyville airport on July 29, 2022
*/
SELECT
    *
FROM
    flights
WHERE
    origin_airport_id
IN
(
    SELECT
    id
    FROM
        airports
    WHERE
        city = 'Fiftyville'
)
AND
    year = 2021 AND month = 7 AND day = 29
ORDER BY
    hour, minute
LIMIT 1;

/*
Now I get the first flight out of Fiftyville on the next day after the theft.
I ordered by hour and minute to get the first flight on the day.
So now I need to check the passengers on flight 36.
+----+-------------------+------------------------+------+-------+-----+------+--------+
| id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
+----+-------------------+------------------------+------+-------+-----+------+--------+
| 36 | 8                 | 4                      | 2021 | 7     | 29  | 8    | 20     |
+----+-------------------+------------------------+------+-------+-----+------+--------+

SO, find all the people who were on flight 36.
*/
SELECT
    *
FROM
    people p, passengers ps
WHERE
    p.passport_number = ps.passport_number
AND
    flight_id =
(
    SELECT
        id
    FROM
        flights
    WHERE
        origin_airport_id
    IN
    (
        SELECT
        id
        FROM
            airports
        WHERE
            city = 'Fiftyville'
    )
    AND
        year = 2021 AND month = 7 AND day = 29
    ORDER BY
        hour, minute
    LIMIT 1
);
/*
passengers on the first flight out of Fiftyville on July 29, 2021
    +--------+--------+----------------+-----------------+---------------+-----------+-----------------+------+
    |   id   |  name  |  phone_number  | passport_number | license_plate | flight_id | passport_number | seat |
    +--------+--------+----------------+-----------------+---------------+-----------+-----------------+------+
    | 953679 | Doris  | (066) 555-9701 | 7214083635      | M51FA04       | 36        | 7214083635      | 2A   |
    | 398010 | Sofia  | (130) 555-0289 | 1695452385      | G412CB7       | 36        | 1695452385      | 3B   |
    | 686048 | Bruce  | (367) 555-5533 | 5773159633      | 94KL13X       | 36        | 5773159633      | 4A   |
    | 651714 | Edward | (328) 555-1152 | 1540955065      | 130LD9Z       | 36        | 1540955065      | 5C   |
    | 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       | 36        | 8294398571      | 6C   |
    | 449774 | Taylor | (286) 555-6063 | 1988161715      | 1106N58       | 36        | 1988161715      | 6D   |
    | 395717 | Kenny  | (826) 555-1652 | 9878712108      | 30G67EN       | 36        | 9878712108      | 7A   |
    | 467400 | Luca   | (389) 555-5198 | 8496433585      | 4328GD8       | 36        | 8496433585      | 7B   |
    +--------+--------+----------------+-----------------+---------------+-----------+-----------------+------+
    Now check which of the 2 remaining suspects passport_number is among the passenger list.
*/




/*
 Now, select the person who made a phone call around the time of the theift with a duration less than 1 minute (60 seconds),
 and who also made a withdrawal at the ATM at Leggett Street on the day
 and who also exited the bakery parking lot within 10 minutes of the theft
 and who also has their passpoert_number listed on the passenger list on the first flight out of Fiftyville on July 29, 2021.
*/

/*
    DRUM ROOOOOOLLLLLLLL.....

    The theif is     :........ Bruce
    The Accomplice is:........ Robin
*/
SELECT
    p.*,
    pc.receiver [Accomplice Phone Number],
    (SELECT name FROM people where phone_number = pc.receiver) [Accomplice],
    pc.duration
FROM
    people p
JOIN
    phone_calls pc
ON p.phone_number = pc.caller
WHERE
    pc.caller
IN
(
    -- get all the persons who made a withdrawal at the ATM at Leggett Street,
    -- and who also exited the bakery parking lot within 10 minutes of the theft.
    SELECT
        p.phone_number
    FROM
        people p, bank_accounts ba, atm_transactions a
    WHERE
        p.id = ba.person_id
    AND
        ba.account_number = a.account_number
    AND
        ba.person_id
    IN
    (
        -- get all the persons exiting the bakery parking lot within 10 minutes of theft
        SELECT
            p.id
        FROM
            people p
        JOIN
            bakery_security_logs b
        ON
            p.license_plate = b.license_plate
        WHERE p.license_plate
        IN
        (
            SELECT
                license_plate
            FROM
                bakery_security_logs
            WHERE
                year = 2021 AND month = 7 and day = 28 AND hour = 10 AND activity = 'exit'
        )
        AND
            b.activity = 'exit' AND minute BETWEEN 15 AND 25
    )
    AND
        a.year = 2021 AND month = 7 AND day = 28
    AND atm_location = 'Leggett Street'AND transaction_type = 'withdraw'
)
AND
    year = 2021 AND month = 7 AND day = 28 AND duration < 60
AND
    p.passport_number
IN -- first flight from Fiftyville airport on July 29, 2021..
(
    SELECT
        ps.passport_number
    FROM
        people p, passengers ps
    WHERE
        p.passport_number = ps.passport_number
    AND
        flight_id =
    (
        SELECT
            id
        FROM
            flights
        WHERE
            origin_airport_id
        IN
        (
            SELECT
            id
            FROM
                airports
            WHERE
                city = 'Fiftyville'
        )
        AND
            year = 2021 AND month = 7 AND day = 29
        ORDER BY
            hour, minute
        LIMIT 1
    )
);

/*
+--------+-------+----------------+-----------------+---------------+-------------------------+------------+----------+
|   id   | name  |  phone_number  | passport_number | license_plate | Accomplice Phone Number | Accomplice | duration |
+--------+-------+----------------+-----------------+---------------+-------------------------+------------+----------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | (375) 555-8161          | Robin      | 45       |
+--------+-------+----------------+-----------------+---------------+-------------------------+------------+----------+
*/



/*
Now lets find which city the thief ESCAPED to.
The flight number is 36...so I can look up the
destination city from the airports table using the
destination_airport_id within the flights table.
*/
SELECT
    city
FROM
    airports
WHERE
    id
IN
(
    SELECT
        destination_airport_id
    FROM
        flights
    WHERE
        id = 36
);
/*
    +---------------+
    |     city      |
    +---------------+
    | New York City |
    +---------------+
*/



/*
    MYSTERY SOLVED
    PHEEWW!!!!..... :)

    THIS WAS EXTREMELY! EXTREMELY! EXTREMELY! FUN!!!!!!!
*/

