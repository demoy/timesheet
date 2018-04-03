create database timesheet;
use timesheet;


create user 'basic'@'localhost' identified by '9ik0ol';
grant select, insert on timesheet.* to 'basic'@'localhost';
flush privileges;


CREATE TABLE pos(
pos_id int(5) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
title varchar(100) NOT NULL
);

CREATE TABLE employee(
eid int(6) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
fam_nam varchar(30),
pers_nam varchar(30), 
oth_nam varchar(30),
pos_id int(5) UNSIGNED NOT NULL,
FOREIGN KEY(pos_id) REFERENCES pos(pos_id)
);

CREATE TABLE address(
eid int(6) UNSIGNED NOT NULL PRIMARY KEY,
street varchar(50),
district varchar(50),
region varchar(20),
country_code varchar(2),
FOREIGN KEY (eid) REFERENCES employee(eid)
);

CREATE TABLE phon_num(
eid int(6) UNSIGNED NOT NULL PRIMARY KEY,
direct boolean NOT NULL,
FOREIGN KEY (eid) REFERENCES employee(eid)
);

CREATE TABLE passw(
eid int(6) UNSIGNED NOT NULL PRIMARY KEY,
pass_hash varchar(40) NOT NULL,
FOREIGN KEY (eid) REFERENCES employee(eid)
);

CREATE TABLE client(
client_id int(4) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
client_nam varchar(40) NOT NULL,
eid int(6) UNSIGNED NOT NULL,
FOREIGN KEY (eid) REFERENCES employee(eid)
);

CREATE TABLE sheet(
sheet_id int(60) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
eid int(6) UNSIGNED NOT NULL,
work_title varchar(40) NOT NULL,
client_id int(4) UNSIGNED NOT NULL,
FOREIGN KEY (eid) REFERENCES employee(eid),
FOREIGN KEY (client_id) REFERENCES client(client_id)
);

CREATE TABLE period(
sheet_id int(60) UNSIGNED NOT NULL,
start_period datetime NOT NULL,
end_period datetime NOT NULL,
PRIMARY KEY(sheet_id, start_period),
FOREIGN KEY (sheet_id) REFERENCES sheet(sheet_id)
);

CREATE TABLE period_comment(
sheet_id int(60) UNSIGNED NOT NULL,
start_period datetime NOT NULL,
commt varchar(300),
PRIMARY KEY(sheet_id, start_period),
FOREIGN KEY (sheet_id, start_period) REFERENCES period(sheet_id, start_period)
);

INSERT INTO pos(title) VALUES ('Managing Director'), ('Senior Consultant'), ('Entry Clerk'), ('Software Developer'), ('Receptionist');
INSERT INTO employee(fam_nam, pers_nam, oth_nam, pos_id) VALUES ('Smith','Gabriel','',1),  ('Joel','Billy','',2), ('Garden','Kelly','',3), ('Eleza','Mikki','',4), ('Adams','Romiel','',5);
INSERT INTO passw(eid, pass_hash) VALUES (1,111111),(2,111111),(3,111111),(4,111111),(5,111111);
INSERT INTO client(client_nam, eid) VALUES ('Viral Works', 1),('Discount Apps', 2);
