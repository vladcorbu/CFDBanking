CREATE TABLE tblClient
(
    client_id        int         NOT NULL,
    Nume_Prenume     varchar(30) NOT NULL,
    Telefon          varchar(20) NOT NULL UNIQUE,
    sursa_venit      varchar(30) DEFAULT NULL,
    CNP              char(13)    NOT NULL UNIQUE,
    serie_nr_buletin char(8)     NOT NULL UNIQUE,

    PRIMARY KEY (client_id)
);

CREATE TABLE tblCont
(
    contbnc_id            int            NOT NULL,
    IBAN                  char(24)       NOT NULL UNIQUE,
    limita_tranzactionare decimal(10, 2) NOT NULL,
    in_moneda             char(3)        NOT NULL,
    sold                  double         NOT NULL,

    PRIMARY KEY (contbnc_id)
);

CREATE TABLE tblCardCredit
(
    card_id        int         NOT NULL,
    nr_card        varchar(19) NOT NULL UNIQUE,
    data_expirarii date        NOT NULL,
    CVV            varchar(4)  NOT NULL,
    tip_card       varchar(16) NOT NULL,
    contbnc_id     int         NOT NULL,
    sold           double      NOT NULL,


    PRIMARY KEY (card_id),
    CONSTRAINT FK_detaliicard_tblCont FOREIGN KEY (contbnc_id) REFERENCES tblCont (contbnc_id)
);

CREATE TABLE tbltranzactii
(
    tranzactie_id     int         NOT NULL,
    card_id           int         NOT NULL,
    data_tranzactie   timestamp   NOT NULL,
    destinatar        varchar(30) NOT NULL,
    suma              double      NOT NULL,
    plata_la          varchar(11) NOT NULL,
    status_tranzactie varchar(8)  NOT NULL,

    PRIMARY KEY (tranzactie_id),
    CONSTRAINT FK_tranz_card FOREIGN KEY (card_id) REFERENCES tblCardCredit (card_id)
);

CREATE TABLE tblDetine
(
    client_id     int NOT NULL,
    contbnc_id    int NOT NULL,

    CONSTRAINT FK_detine_tblCont FOREIGN KEY (contbnc_id) REFERENCES tblCont (contbnc_id),
    CONSTRAINT FK_detine_client FOREIGN KEY (client_id) REFERENCES tblClient (client_id)

);

/*#############################################################*/




/*#############################################################*/
/*         PARTEA 3 - INSERAREA INREGISTRARILOR IN TABELE      */

INSERT INTO tblClient
VALUES (1, 'Dobrota Mihai', '0764982712', 'Constant S.A.',
        '1770607178567', 'BV178451');
INSERT INTO tblClient
VALUES (2, 'Dobrota Maria', '0752490001', 'Distribution S.R.L',
        '1750923100913', 'BV681921');
INSERT INTO tblClient
VALUES (3, 'Dobrota Andrei-Constantin', '0761900874', DEFAULT,
        '5021214572812', 'BV817045');
INSERT INTO tblClient
VALUES (4, 'Costea Mariana', '0788001812', 'Avantaj S.R.L',
        '1720814900189', 'XT971413');
INSERT INTO tblClient
VALUES (5, 'Radoi Marinelo', '0764899102', 'Express Army S.A.',
        '1730120198371', 'XZ200183');
INSERT INTO tblClient
VALUES (6, 'Radoi Radu-Alin', '0751987143', DEFAULT,
        '1990218157291', 'XZ100131');
INSERT INTO tblClient
VALUES (7, 'Enescu Bogdan', '0771491021', 'Colegiul B.P. Hasdeu',
        '1640314195712', 'XZ167901');
INSERT INTO tblClient
VALUES (8, 'Velea Alexandru', '0790892182', 'Golden Boy Society',
        '1850712100893', 'DP671921');
INSERT INTO tblClient
VALUES (9, 'Mirica Andrei', '0772900761', 'Dental Practice S.A.',
        '1970426195712', 'XZ190717');
INSERT INTO tblClient
VALUES (10, 'Mocanu Stefan', '0734981555', DEFAULT,
        '1990410681920', 'XZ885719');
INSERT INTO tblClient
VALUES (11, 'Bordei Andrei', '0759018232', 'Star Expert S.R.L.',
        '1841111192845', 'MM884271');

INSERT INTO tblCont
VALUES (182, 'RO30RZBR3462673662769386', 90000, 'RON', 1256432.55);
INSERT INTO tblCont
VALUES (19, 'RO36RZBR9686879545628542', 50000, 'RON', 589102.22);
INSERT INTO tblCont
VALUES (278, 'RO27RZBR4258369836428467', 150000, 'RON', 2519627.89);
INSERT INTO tblCont
VALUES (991, 'RO79PORL2293299972448727', 5000, 'RON', 51293.65);
INSERT INTO tblCont
VALUES (521, 'RO05PORL7821241556299868', 7000, 'RON', 100942.9);
INSERT INTO tblCont
VALUES (87, 'RO30RZBR3382693228563167', 9000, 'EUR', 612829.3);
INSERT INTO tblCont
VALUES (612, 'RO25RZBR3649834651266651', 19000, 'EUR', 589192.56);
INSERT INTO tblCont
VALUES (93, 'RO69PORL9158253541738397', 10000, 'GBP', 278192.01);
INSERT INTO tblCont
VALUES (253, 'RO49RZBR8737682929643667', 10000, 'USD', 77012.15);
INSERT INTO tblCont
VALUES (423, 'RO75PORL4938259892753271', 100000, 'RON', 516429.76);
INSERT INTO tblCont
VALUES (109, 'RO33RZBR1265648445882593', 50000, 'RON', 191203.86);
INSERT INTO tblCont
VALUES (721, 'RO09PORL9894452765249483', 50000, 'RON', 169201);
INSERT INTO tblCont
VALUES (678, 'RO74RZBR5159341735755917', 20000, 'RON', 129102.4);
INSERT INTO tblCont
VALUES (123, 'RO74RZBR8291823591726591', 20000, 'RON', 129102.4);
INSERT INTO tblCont
VALUES (600, 'RO74RZBR9248712598219507', 2000, 'RON', 9892.4);

INSERT INTO tblCardCredit
VALUES (5, '4556 0859 1183 8242', '2024-04-30', '461', 'VISA', 278, 5781.87);
INSERT INTO tblCardCredit
VALUES (10, '4024 0071 0180 4143', '2022-08-30', '889', 'VISA', 278, 106987.76);
INSERT INTO tblCardCredit
VALUES (15, '4716 2123 8252 0342', '2025-01-30', '752', 'VISA', 19, 56294.93);
INSERT INTO tblCardCredit
VALUES (20, '5136 1105 6758 6907', '2023-06-30', '771', 'MasterCard', 278, 2671.98);
INSERT INTO tblCardCredit
VALUES (25, '5352 8321 4718 5267', '2021-12-30', '152', 'MasterCard', 991, 5629.93);
INSERT INTO tblCardCredit
VALUES (30, '3737 043329 20129', '2023-04-30', '6291', 'American Express', 253, 10067.9);
INSERT INTO tblCardCredit
VALUES (35, '4929 6808 6420 9472', '2023-12-30', '701', 'VISA', 423, 20941.65);
INSERT INTO tblCardCredit
VALUES (40, '4485 8556 7398 7486', '2024-03-30', '655', 'VISA', 423, 3621.26);
INSERT INTO tblCardCredit
VALUES (45, '5351 4121 6919 8539', '2024-06-30', '928', 'MasterCard', 612, 104826.74);
INSERT INTO tblCardCredit
VALUES (50, '5187 2592 7099 5372', '2023-03-30', '561', 'MasterCard', 123, 5782.86);
INSERT INTO tblCardCredit
VALUES (55, '5505 6325 2325 7060', '2022-10-30', '866', 'MasterCard', 123, 3894.09);
INSERT INTO tblCardCredit
VALUES (60, '5351 7892 4921 5962', '2024-03-30', '782', 'MasterCard', 109, 90572.46);
INSERT INTO tblCardCredit
VALUES (65, '6011 3050 7242 8573', '2022-01-30', '415', 'Discover', 678, 109485.24);
INSERT INTO tblCardCredit
VALUES (70, '6011 3322 4233 2451', '2023-01-30', '612', 'Discover', 521, 1099.24);
INSERT INTO tblCardCredit
VALUES (75, '4929 5017 4773 5675', '2024-08-30', '888', 'VISA', 600, 4572.93);

INSERT INTO tbltranzactii
VALUES (1, 10, '2021-10-20 14:50:21', 'DEDEMAN S.R.L.', 957.9, 'POS', 'aprobata');
INSERT INTO tbltranzactii
VALUES (2, 10, '2021-10-20 15:01:49', 'IKEA ROMANIA S.A.', 1407.67, 'Third Party', 'aprobata');
INSERT INTO tbltranzactii
VALUES (3, 15, '2021-11-07 18:59:04', 'Socului Kebab', 26, 'POS', 'aprobata');
INSERT INTO tbltranzactii
VALUES (4, 35, '2021-10-30 20:23:41', 'Mihaiescu Cornel', 200000, 'Third Party', 'respinsa');
INSERT INTO tbltranzactii
VALUES (5, 35, '2021-11-01 23:23:06', 'Radoi Radu-Alin', 200, 'Third Party', 'aprobata');
INSERT INTO tbltranzactii
VALUES (6, 30, '2021-10-24 16:34:12', 'eMAG', 3400, 'online', 'aprobata');
INSERT INTO tbltranzactii
VALUES (7, 60, '2021-11-03 13:06:24', 'Car Dealership S.R.L.', 1000000, 'POS', 'respinsa');
INSERT INTO tbltranzactii
VALUES (8, 55, '2021-11-06 16:59:04', 'Kings Of Hair Barbers', 40, 'POS', 'aprobata');
INSERT INTO tbltranzactii
VALUES (9, 55, '2021-10-21 11:19:31', 'Expert Printing S.R.L.', 14.5, 'POS', 'aprobata');
INSERT INTO tbltranzactii
VALUES (10, 45, '2021-11-05 04:09:23', 'Ciobanu Liviu', 600, 'online', 'aprobata');
INSERT INTO tbltranzactii
VALUES (11, 75, '2021-11-02 00:04:45', 'Mocanu Stefan', 1000, 'Third Party', 'aprobata');

INSERT INTO tblDetine
VALUES (1, 278);
INSERT INTO tblDetine
VALUES (3, 278);
INSERT INTO tblDetine
VALUES (2, 19);
INSERT INTO tblDetine
VALUES (7, 253);
INSERT INTO tblDetine
VALUES (7, 19);
INSERT INTO tblDetine
VALUES (4, 991);
INSERT INTO tblDetine
VALUES (5, 423);
INSERT INTO tblDetine
VALUES (6, 423);
INSERT INTO tblDetine
VALUES (8, 612);
INSERT INTO tblDetine
VALUES (9, 123);
INSERT INTO tblDetine
VALUES (10, 123);
INSERT INTO tblDetine
VALUES (4, 182);
INSERT INTO tblDetine
VALUES (8, 87);
INSERT INTO tblDetine
VALUES (8, 93);
INSERT INTO tblDetine
VALUES (9, 109);
INSERT INTO tblDetine
VALUES (11, 721);
INSERT INTO tblDetine
VALUES (11, 678);
INSERT INTO tblDetine
VALUES (5, 521);
INSERT INTO tblDetine
VALUES (9, 600);
