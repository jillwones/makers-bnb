CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  phone_number text,
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
  booked text,
  user_id int,
  constraint fk_user foreign key(user_id) references users(id),
  listing_id int,
  constraint fk_listing foreign key(listing_id) references listings(id)
);

CREATE TABLE dates_available (
  id SERIAL PRIMARY KEY,
  date_available date,
  listing_id int,
  constraint fk_listing foreign key(listing_id) references listings(id)
);

CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  content text,
  date_time TIMESTAMP,
  host_id int,
  constraint fk_host foreign key(host_id) references users(id),
  user_id int,
  constraint fk_user foreign key(user_id) references users(id),
  sender_id int,
  constraint fk_sender foreign key(sender_id) references users(id)
);