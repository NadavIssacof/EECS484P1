CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    year_of_birth INTEGER,	 
    month_of_birth INTEGER,	 
    day_of_birth INTEGER,	 
    gender VARCHAR2(100)
);

CREATE TABLE FRIENDS (
    user1_id INTEGER NOT NULL,
    user2_id INTEGER NOT NULL,
    PRIMARY KEY (user1_id, user2_id),
    CONSTRAINT fk_user1_id FOREIGN KEY (user1_id) REFERENCES Users (user_id),
    CONSTRAINT fk_user2_id FOREIGN KEY (user2_id) REFERENCES Users (user_id)
);

CREATE TRIGGER Order_Friend_Pairs
    BEFORE INSERT ON Friends
    FOR EACH ROW
        DECLARE temp INTEGER;
        BEGIN
            IF :NEW.user1_id > :NEW.user2_id THEN
                temp := :NEW.user2_id;
                :NEW.user2_id := :NEW.user1_id;
                :NEW.user1_id := temp;
            END IF;
        END;
/

CREATE TABLE Cities(
    city_id	INTEGER	PRIMARY KEY,
    city_name VARCHAR2(100) NOT NULL,
    state_name VARCHAR2(100) NOT NULL,
    country_name VARCHAR2(100) NOT NULL,
    CONSTRAINT unique_csc UNIQUE (city_name, state_name, country_name)
);

CREATE TABLE User_Current_Cities(
    user_id	INTEGER	NOT NULL,
    current_city_id	INTEGER	NOT NULL,
    PRIMARY KEY (user_id, current_city_id),
    CONSTRAINT fk_curr_city_user FOREIGN KEY (user_id) REFERENCES Users (user_id),
    CONSTRAINT fk_curr_city_city FOREIGN KEY (current_city_id) REFERENCES Cities (city_id)
);

CREATE TABLE User_Hometown_Cities(
    user_id	INTEGER	NOT NULL,
    hometown_city_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, hometown_city_id),
    CONSTRAINT fk_home_city_user FOREIGN KEY (user_id) REFERENCES Users (user_id),
    CONSTRAINT fk_home_city_city FOREIGN KEY (hometown_city_id) REFERENCES Cities (city_id)
);

CREATE TABLE Messages(
    message_id INTEGER PRIMARY KEY,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER	NOT NULL,
    message_content VARCHAR2(2000) NOT NULL,
    sent_time TIMESTAMP	NOT NULL,
    CONSTRAINT fk_mess_sender FOREIGN KEY (sender_id) REFERENCES Users (user_id),
    CONSTRAINT fk_mess_receiver FOREIGN KEY (receiver_id) REFERENCES Users (user_id)
);

CREATE TABLE Programs(
    program_id INTEGER PRIMARY KEY,
    institution VARCHAR2(100) NOT NULL,
    concentration VARCHAR2(100) NOT NULL,
    degree VARCHAR2(100) NOT NULL,
    CONSTRAINT unique_icd UNIQUE (institution, concentration, degree)
);

CREATE TABLE Education(
    user_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    program_year INTEGER NOT NULL,
    PRIMARY KEY (user_id, program_id, program_year),
    -- PRIMARY KEY (user_id, program_id)
    CONSTRAINT fk_edu_user FOREIGN KEY (user_id) REFERENCES Users (user_id),
    CONSTRAINT fk_edu_program FOREIGN KEY (program_id) REFERENCES Program (program_id),
    CONSTRAINT unique_up UNIQUE (user_id, program_id)
);

CREATE TABLE User_Events(
    event_id INTEGER PRIMARY KEY,
    event_creator_id INTEGER NOT NULL,
    event_name VARCHAR2(100) NOT NULL,
    event_tagline VARCHAR2(100),
    event_description VARCHAR2(100),
    event_host VARCHAR2(100),
    event_type VARCHAR2(100),
    event_subtype VARCHAR2(100),
    event_address VARCHAR2(2000),
    event_city_id INTEGER NOT NULL,
    event_start_time TIMESTAMP,
    event_end_time TIMESTAMP,
    CONSTRAINT fk_event_user FOREIGN KEY (event_creator_id) REFERENCES Users (user_id),
    CONSTRAINT fk_event_city FOREIGN KEY (event_city_id) REFERENCES Cities (city_id)
);

CREATE TABLE Participants(
    event_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, event_id),
    confirmation VARCHAR2(100) NOT NULL CHECK (confirmation IN ('Attending', 'Unsure', 'Declines', 'Not_Replied')),
    CONSTRAINT fk_part_event FOREIGN KEY (event_id) REFERENCES User_Events (event_id),
    CONSTRAINT fk_part_user FOREIGN KEY (user_id) REFERENCES Users (user_id)
);

CREATE TABLE Albums(
    album_id INTEGER PRIMARY KEY,
    album_owner_id INTEGER NOT NULL,
    album_name VARCHAR2(100) NOT NULL,
    album_created_time TIMESTAMP NOT NULL,
    album_modified_time TIMESTAMP,	 
    album_link VARCHAR2(2000) NOT NULL,
    album_visibility VARCHAR2(100) NOT NULL CHECK (album_visibility IN ('Everyone', 'Friends', 'Friends_Of_Friends', 'Myself')),
    cover_photo_id INTEGER NOT NULL,
    CONSTRAINT fk_album_user FOREIGN KEY (album_owner_id) REFERENCES Users (user_id)
);

CREATE TABLE Photos(
    photo_id INTEGER PRIMARY KEY,
    album_id INTEGER NOT NULL,
    photo_caption VARCHAR2(2000),	 
    photo_created_time TIMESTAMP NOT NULL,
    photo_modified_time	TIMESTAMP, 
    photo_link VARCHAR2(2000) NOT NULL,
    -- FOREIGN KEY (album_id) REFERENCES Albums (album_id)
);

CREATE TABLE Tags(
    tag_photo_id INTEGER PRIMARY KEY,
    tag_subject_id INTEGER NOT NULL,
    tag_created_time TIMESTAMP NOT NULL,
    tag_x NUMBER NOT NULL,
    tag_y NUMBER NOT NULL,
    CONSTRAINT fk_tag_photo FOREIGN KEY (tag_photo_id) REFERENCES Photos (photo_id),
    CONSTRAINT fk_tag_user FOREIGN KEY (tag_subject_id) REFERENCES Users (user_id),
    CONSTRAINT unique_ps UNIQUE (tag_photo_id, tag_subject_id)
);

--Circular Dependencies

ALTER TABLE Albums ADD CONSTRAINT Circ_cover_photo
FOREIGN KEY (cover_photo_id) REFERENCES Photos(photo_id) INITIALLY DEFERRED DEFERRABLE;

ALTER TABLE Photos ADD CONSTRAINT Circ_album
FOREIGN KEY (album_id) REFERENCES Albums(album_id) INITIALLY DEFERRED DEFERRABLE;

--Sequences

CREATE SEQUENCE city_sequence
    START WITH 1
    INCREMENT BY 1;

CREATE TRIGGER city_trigger
    BEFORE INSERT ON Cities
    FOR EACH ROW
        BEGIN
            SELECT city_sequence.NEXTVAL INTO :NEW.city_id FROM DUAL;
        END;
/

CREATE SEQUENCE program_sequence
    START WITH 1
    INCREMENT BY 1;

CREATE TRIGGER program_trigger
    BEFORE INSERT ON Programs
    FOR EACH ROW
        BEGIN
            SELECT program_sequence.NEXTVAL INTO :NEW.program_id FROM DUAL;
        END;
/
