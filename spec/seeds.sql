CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  email_address text,
  password text
);

CREATE TABLE listings (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price_per_night decimal,
  user_id int,
  constraint fk_user foreign key(user_id) references users(id)
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  name text,
  date date,
  booked boolean,
  user_id int,
  constraint fk_user foreign key(user_id) references users(id),
  listing_id int,
  constraint fk_listing foreign key(listing_id) references listings(id)
);

TRUNCATE TABLE users, listings, bookings RESTART IDENTITY;

INSERT INTO users (name, email_address, password) VALUES ('Jude', 'jude@jude.com', '$2a$12$sO9PRZqxvPyshRD6KP1fS.jIRQjrUn2zbYW2u4HAMz/MjHToNovPa');
INSERT INTO users (name, email_address, password) VALUES ('Aimee', 'aimee@aimee.com', '$2a$12$ra6XG3WgBaYau.tUB6i.LOl1a3tYn1pq/p909.h4JSYIYovR5XRZ.');
INSERT INTO users (name, email_address, password) VALUES ('Henry', 'henry@henry.com', '$2a$12$gldUm1M2yofJkVo7WHJyX.2HEHQGCwquMgTK8mQm9JLZa.27TFn5K');
INSERT INTO users (name, email_address, password) VALUES ('Andy', 'andy@andy.com', '$2a$12$.TtSIasCntWicYgomeeAWOjaWmCQ4lCwEr0hQvJk/QJUhnvZoDAiS');
INSERT INTO users (name, email_address, password) VALUES ('Will', 'will@will.com', '$2a$12$ayzQb534iEp2sAvJADV4UeNklKJB6isdiCB6rdTTVqpHm2dJFwbZm');

INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Apartment1', 'Two bedrooms in north London', 100, 1);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Apartment2', 'Three bedrooms in central London', 170.50, 2);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('House1', 'Four bedrooms in west London', 280, 3);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('House2', 'Five bedrooms in east London', 100, 4);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('House3', 'Six bedrooms in central London', 100, 5);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Apartment3', 'Studio flat in central London', 85.75, 1);

INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Apartment1', '2022-10-10', true, 2, 1);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Apartment2', '2022-09-09', false, 3, 2);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('House1', '2022-10-20', null, 4, 3);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('House2', '2022-10-11', true, 5, 4);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('House3', '2022-07-28', false, 1, 5);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Apartment3', '2022-10-15', null, 2, 6);