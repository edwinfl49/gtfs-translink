-- create table queries for static files
-- running these scripts will drop all existing tables!
DROP TABLE IF EXISTS agency;
CREATE TABLE agency (
    agency_url varchar(49),
    agency_name varchar(49),
    agency_timezone varchar(28),
    agency_id varchar(2) PRIMARY KEY,
    agency_lang varchar(2)
);

/* table has only 60 rows and may not be relevant for our analysis
DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar (
    service_id varchar(30),
    start_date int,
    end_date int,
    monday bit,
    tuesday bit,
    wednesday bit,
    thursday bit,
    friday bit,
    saturday bit,
    sunday bit
)
*/

DROP TABLE IF EXISTS calendar_dates;
CREATE TABLE calendar (
    service_id varchar(30) PRIMARY KEY,
    date bigint,
    exception_type smallint
);

DROP TABLE IF EXISTS direction_names_exceptions;
CREATE TABLE direction_names_exceptions (
    route_name varchar(20),
    direction_id smallint
    direction_name varchar(49),
    direction_do smallint,
    PRIMARY KEY (route_name, direction_id)
);

DROP TABLE IF EXISTS routes;
CREATE TABLE routes (
    route_long_name varchar(49),
    route_type smallint,
    route_text_color char(6),
    route_color char(6),
    agency_id varchar(2),
    route_id int,
    route_url varchar(99),
    route_desc varchar(49),
    route_short_name varchar(3),
    PRIMARY KEY (route_id)
);

DROP TABLE IF EXISTS shapes;
CREATE TABLE shapes (
    shape_id int,
    shape_pt_lat numeric(9,6),
    shape_pt_lon numeric(9,6),
    shape_pt_sequence smallint,
    shape_dist_traveled numeric(7,4),
    PRIMARY KEY (shape_id, shape_pt_lat, shape_pt_lon)
);

DROP TABLE IF EXISTS stop_order_exceptions;
CREATE TABLE stop_order_exceptions (
    route_name varchar(20),
    direction_name varchar(10),
    direction_do smallint,
    stop_id smallint,
    stop_name varchar(49),
    stop_do smallint
);

DROP TABLE IF EXISTS stop_times;
CREATE TABLE stop_times (
    trip_id int,
    arrival_time varchar(8), -- in 24hr format of hh:mm:ss
    departure_time varchar(8),
    stop_id smallint,
    stop_sequence smallint,
    stop_headsign varchar(49),
    pickup_type varchar(10),
    drop_off_type varchar(10),
    shape_dist_traveled numeric(7,4),
    timepoint smallint,
    PRIMARY KEY (trip_id, stop_id)
);

DROP TABLE IF EXISTS stops;
CREATE TABLE stops (
    stop_lat numeric(9,6),
    stop_code smallint,
    stop_lon numeric(9,6),
    stop_id smallint,
    stop_url varchar(49),
    parent_station varchar(49),
    stop_desc varchar(99),
    stop_name varchar(99),
    location_type smallint,
    zone_id varchar(10),
    PRIMARY KEY (stop_id)
);

DROP TABLE IF EXISTS trips;
CREATE TABLE trips (
    block_id varchar(9),
    bikes_allowed bit,
    route_id smallint,
    wheelchair_accessible bit,
    direction_id smallint,
    trip_headsign varchar(30),
    shape_id int,
    service_id varchar(30),
    trip_id int,
    trip_short_name varchar(10)
);