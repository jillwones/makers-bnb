TRUNCATE TABLE users, listings, bookings, dates_available, messages RESTART IDENTITY;

INSERT INTO users (name, phone_number, email_address, password) VALUES ('Jude', '+447877916281', 'jude@jude.com', '$2a$12$sO9PRZqxvPyshRD6KP1fS.jIRQjrUn2zbYW2u4HAMz/MjHToNovPa');
INSERT INTO users (name, phone_number, email_address, password) VALUES ('Aimee', '+447854988179', 'aimee@aimee.com', '$2a$12$ra6XG3WgBaYau.tUB6i.LOl1a3tYn1pq/p909.h4JSYIYovR5XRZ.');
INSERT INTO users (name, phone_number, email_address, password) VALUES ('Henry', '+447921846335', 'henry@henry.com', '$2a$12$gldUm1M2yofJkVo7WHJyX.2HEHQGCwquMgTK8mQm9JLZa.27TFn5K');
INSERT INTO users (name, phone_number, email_address, password) VALUES ('Andy','+447741542803', 'andy@andy.com', '$2a$12$.TtSIasCntWicYgomeeAWOjaWmCQ4lCwEr0hQvJk/QJUhnvZoDAiS');
INSERT INTO users (name, phone_number, email_address, password) VALUES ('Will', '+447379766090', 'will@will.com', '$2a$12$ayzQb534iEp2sAvJADV4UeNklKJB6isdiCB6rdTTVqpHm2dJFwbZm');

INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Contemporary 2nd Floor Apartment', 'Two bedrooms with en suites in an amazing location in north London', 100, 1);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Countryside Escape', 'Fully furnished three bedroom home with a fireplace in the English Countryside', 170.50, 2);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Beautiful Period House', 'Four bedroom house in the posh suburbs of West London', 280, 3);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Spacious Family Home', 'Five bedrooms with incredible natural light in trendy East London', 100, 4);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Luxurious Town House', 'Six bedrooms in the heart of Central London with concierge service and parking', 100, 5);
INSERT INTO listings (name, description, price_per_night, user_id) VALUES ('Cosy Ground Floor Loft', 'Cosy Loft in Central London with off street parking', 85.75, 1);

INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Contemporary 2nd floor Apartment ', '2023-10-10', 'yes', 2, 1);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Countryside Escape', '2023-09-10', 'no', 3, 2);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Beautiful Period House', '2023-12-12', 'pending', 4, 3);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Spacious Family Home', '2023-05-01', 'yes', 5, 4);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Luxurious Town House', '2023-03-01', 'no', 1, 5);
INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ('Cosy Ground Floor Loft', '2023-12-11', 'pending', 2, 6);

INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-10-10', 1);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-10-11', 1);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-10-12', 1);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-09-10', 2);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-09-11', 2);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-09-12', 2);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-11', 3);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-12', 3);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-13', 3);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-14', 3);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-05-01', 4);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-05-02', 4);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-03-01', 5);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-03-02', 5);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-11', 6);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-12', 6);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-13', 6);
INSERT INTO dates_available (date_available, listing_id) VALUES ('2023-12-14', 6);

INSERT INTO messages (content, date_time, host_id, user_id, sender_id) VALUES ('Hi, I am looking forward to the trip', '2022-12-16 10:30:00', 1, 2, 2);
INSERT INTO messages (content, date_time, host_id, user_id, sender_id) VALUES ('You best pay me', '2022-12-16 10:31:00', 1, 2, 1);
INSERT INTO messages (content, date_time, host_id, user_id, sender_id) VALUES ('Yes, I will', '2022-12-16 10:32:00', 1, 2, 2);
INSERT INTO messages (content, date_time, host_id, user_id, sender_id) VALUES ('Good', '2022-12-16 10:33:00', 1, 2, 1);