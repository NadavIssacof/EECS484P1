--Drop Circular Dependency Constraint
ALTER TABLE Albums DROP CONSTRAINT Circ_cover_photo;
ALTER TABLE Photos DROP CONSTRAINT Circ_album;

--Drop constraints in reverse order
ALTER TABLE Tags DROP CONSTRAINT fk_tag_photo;
ALTER TABLE Tags DROP CONSTRAINT fk_tag_user;
ALTER TABLE Tags DROP CONSTRAINT unique_ps;

ALTER TABLE Albums DROP CONSTRAINT fk_album_user;

ALTER TABLE Participants DROP CONSTRAINT fk_part_user;
ALTER TABLE Participants DROP CONSTRAINT fk_part_event;

ALTER TABLE User_Events DROP CONSTRAINT fk_event_city;
ALTER TABLE User_Events DROP CONSTRAINT fk_event_user;

ALTER TABLE Education DROP CONSTRAINT fk_edu_user;
ALTER TABLE Education DROP CONSTRAINT fk_edu_program;
ALTER TABLE Education DROP CONSTRAINT unique_up;

ALTER TABLE Programs DROP CONSTRAINT unique_icd;

ALTER TABLE Messages DROP CONSTRAINT fk_mess_sender;
ALTER TABLE Messages DROP CONSTRAINT fk_mess_receiver;

ALTER TABLE User_Hometown_Cities DROP CONSTRAINT fk_home_city_user;
ALTER TABLE User_Hometown_Cities DROP CONSTRAINT fk_home_city_city;

ALTER TABLE User_Current_Cities DROP CONSTRAINT fk_curr_city_user;
ALTER TABLE User_Current_Cities DROP CONSTRAINT fk_curr_city_city;

ALTER TABLE Cities DROP CONSTRAINT unique_csc;

ALTER TABLE Friends DROP CONSTRAINT fk_user1_1;
ALTER TABLE Friends DROP CONSTRAINT fk_user2_2;

--Dropping triggers
DROP TRIGGER Order_Friend_Pairs;
DROP TRIGGER city_trigger;
DROP TRIGGER program_trigger;


--Drop Sequence
DROP SEQUENCE city_sequence;
DROP SEQUENCE program_sequence;

--Drop Tables
DROP TABLE Tags;
DROP TABLE Photos;
DROP TABLE Albums;
DROP TABLE Participants;
DROP TABLE User_Events;
DROP TABLE Education;
DROP TABLE Programs;
DROP TABLE User_Current_Cities;
DROP TABLE User_Hometown_Cities;
DROP TABLE Cities;
DROP TABLE Messages;
DROP TABLE Friends;
DROP TABLE Users;